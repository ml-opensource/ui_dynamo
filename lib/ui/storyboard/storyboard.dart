import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ui_dynamo/mediaquery/offset_plugin.dart';
import 'package:ui_dynamo/mediaquery/override_media_query_plugin.dart';
import 'package:ui_dynamo/ui/screen.dart';
import 'package:ui_dynamo/ui/storyboard/flow_start.dart';
import 'package:ui_dynamo/ui/storyboard/utils.dart';
import 'package:ui_dynamo/ui/widgets/panscroll.dart';

const _kSpacing = 80.0;

class StoryBoard extends StatefulWidget {
  /// Wrap your Material App with this widget
  final MaterialApp child;

  /// Specify a set of Flows to display within the default Dynamo
  /// instead of every application route. Each key is the name of the Flow
  /// and each value is the ordered list of screens shown.
  final Map<String, List<String>> routesMapping;

  const StoryBoard({
    Key key,
    @required this.child,
    this.routesMapping,
  }) : super(key: key);

  @override
  StoryboardController createState() => StoryboardController();
}

class StoryboardController extends State<StoryBoard> {
  @override
  void didUpdateWidget(StoryBoard oldWidget) {
    if (oldWidget.child != widget.child) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  double _calculateOffsetTop(Offset offset, MediaQueryData realQuery,
      OverrideMediaQueryProvider provider, OffsetProvider offsetProvider) {
    final offsetTop = Offset(
        0,
        offset.dy +
            (realQuery.size.height - provider.boundedMediaQuery.size.height) /
                2 -
            provider.toolbarHeight);
    return calculateTop(
        offsetTop, offsetProvider.currentOffset, offsetProvider.screenScale);
  }

  double _calculateOffsetLeft(Offset offset, MediaQueryData realQuery,
      OverrideMediaQueryProvider provider, OffsetProvider offsetProvider) {
    final offsetLeft = Offset(
        offset.dx +
            (realQuery.size.width - provider.boundedMediaQuery.size.width) / 2,
        0);
    return calculateLeft(
        offsetLeft, offsetProvider.currentOffset, offsetProvider.screenScale);
  }

  @override
  Widget build(BuildContext context) {
    final query = context.mediaQueryProvider;
    final realQuery = MediaQuery.of(context);
    final mediaQueryData = query.boundedMediaQuery;
    final base = widget.child;
    final size = mediaQueryData.size;
    final offsetProvider = context.offsetProvider;
    return Scaffold(
      body: PanScrollDetector(
        onOffsetChange: (offset) => offsetProvider.offsetChange(offset),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: OverflowBox(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (base?.home != null && widget.routesMapping == null)
                  _addChild(
                    offsetProvider: offsetProvider,
                    base: base,
                    provider: query,
                    realQuery: realQuery,
                    child: base.home,
                    routeName: '/',
                    isFirst: false,
                    isLast: false,
                    offset: Offset(0, 10),
                    label: 'Home',
                  ),
                if (base?.initialRoute != null && widget.routesMapping == null)
                  _addChild(
                    offsetProvider: offsetProvider,
                    base: base,
                    provider: query,
                    realQuery: realQuery,
                    child: base.routes[base.initialRoute](context),
                    routeName: base.initialRoute,
                    isFirst: false,
                    isLast: false,
                    offset: Offset(
                        base?.home != null ? size.width + _kSpacing : 0, 10),
                    label: 'Initial Route',
                  ),
                ..._renderRoutes(query, realQuery, offsetProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _addChild({
    @required MaterialApp base,
    @required Widget child,
    @required String routeName,
    @required bool isFirst,
    @required bool isLast,
    Offset offset = Offset.zero,
    String label,
    @required MediaQueryData realQuery,
    @required OverrideMediaQueryProvider provider,
    @required OffsetProvider offsetProvider,
  }) {
    final top =
        _calculateOffsetTop(offset, realQuery, provider, offsetProvider);
    final left =
        _calculateOffsetLeft(offset, realQuery, provider, offsetProvider);
    return Positioned(
      top: top,
      left: left,
      child: ScalableScreen(
        base: widget.child,
        child: child,
        label: label,
        routeName: routeName,
        viewPortSize: provider.viewportSize,
        screenScale: offsetProvider.screenScale,
        boundedMediaQuery: provider.boundedMediaQuery,
      ),
    );
  }

  Positioned _addSectionStart({
    @required MaterialApp base,
    Offset offset = Offset.zero,
    String label,
    @required MediaQueryData realQuery,
    @required OverrideMediaQueryProvider provider,
    @required String nextRoute,
    @required OffsetProvider offsetProvider,
  }) {
    final top =
        _calculateOffsetTop(offset, realQuery, provider, offsetProvider);
    final left =
        _calculateOffsetLeft(offset, realQuery, provider, offsetProvider);
    return Positioned(
      top: top,
      left: left,
      child: ScalableScreen(
        base: widget.child,
        child: FlowStart(label: label),
        label: label,
        isFlowStart: true,
        routeName: nextRoute,
        viewPortSize: provider.viewportSize,
        boundedMediaQuery: provider.boundedMediaQuery,
        screenScale: offsetProvider.screenScale,
      ),
    );
  }

  _renderRoutes(OverrideMediaQueryProvider provider, MediaQueryData realQuery,
      OffsetProvider offsetProvider) {
    final List<Widget> routesList = [];
    final base = widget.child;
    final _size = provider.boundedMediaQuery.size;
    final mapping = widget.routesMapping;
    if (mapping?.isNotEmpty == true) {
      var index = 0;
      mapping.entries.forEach((entry) {
        var offsetIndex = 0;
        routesList.add(_addSectionStart(
          offsetProvider: offsetProvider,
          provider: provider,
          realQuery: realQuery,
          base: base,
          offset: Offset((_size.width + _kSpacing) * (offsetIndex),
              ((_size.height + _kSpacing) + 40) * index),
          label: entry.key,
          nextRoute: entry.value[0],
        ));
        entry.value.forEach((route) {
          final currentRoute = base.routes[route];
          assert(() {
            if (currentRoute == null) {
              throw FlutterError(
                  "Could not find a route mapping for $route in application routes");
            }
            return true;
          }());
          routesList.add(_addChild(
            offsetProvider: offsetProvider,
            base: base,
            provider: provider,
            realQuery: realQuery,
            child: currentRoute(context),
            routeName: route,
            isFirst: false,
            isLast: (offsetIndex == entry.value.length - 1),
            offset: Offset((_size.width + _kSpacing) * (offsetIndex + 1),
                ((_size.height + _kSpacing) + 40) * index),
            label: route,
          ));
          offsetIndex++;
        });
        index++;
      });
    } else if (base?.routes != null) {
      for (var r = 0; r < base.routes.keys.length; r++) {
        routesList.add(_addChild(
          offsetProvider: offsetProvider,
          provider: provider,
          realQuery: realQuery,
          base: base,
          child: base.routes[base.routes.keys.toList()[r]](context),
          routeName: base.routes.keys.toList()[r],
          isFirst: false,
          isLast: false,
          offset: Offset(
              (_size.width + _kSpacing) * r, (_size.height + _kSpacing) + 40),
          label: base.routes.keys.toList()[r],
        ));
      }
    }
    return routesList;
  }
}

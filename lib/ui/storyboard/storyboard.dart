import 'package:flutter/material.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/screen.dart';
import 'package:flutter_storybook/ui/storyboard/flow_start.dart';
import 'package:flutter_storybook/ui/storyboard/utils.dart';

const _kSpacing = 80.0;

class StoryBoard extends StatefulWidget {
  /// Wrap your Material App with this widget
  final MaterialApp child;

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
      OverrideMediaQueryProvider provider) {
    final offsetTop = Offset(
        0,
        offset.dy +
            (realQuery.size.height - provider.boundedMediaQuery.size.height) /
                2 -
            provider.toolbarHeight);
    return calculateTop(
        offsetTop, provider.currentOffset, provider.screenScale);
  }

  double _calculateOffsetLeft(Offset offset, MediaQueryData realQuery,
      OverrideMediaQueryProvider provider) {
    final offsetLeft = Offset(
        (realQuery.size.width - provider.boundedMediaQuery.size.width) / 2, 0);
    return calculateLeft(
        offsetLeft, provider.currentOffset, provider.screenScale);
  }

  @override
  Widget build(BuildContext context) {
    final query = mediaQuery(context);
    final realQuery = MediaQuery.of(context);
    final mediaQueryData = query.boundedMediaQuery;
    final base = widget.child;
    final size = mediaQueryData.size;
    final scale = query.screenScale;
    final currentOffset = query.currentOffset;
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (panDetails) => query.offsetChange(panDetails.delta),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: OverflowBox(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (base?.home != null && widget.routesMapping == null)
                  _addChild(
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
                ..._renderRoutes(query),
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
  }) {
    final top = _calculateOffsetTop(offset, realQuery, provider);
    final left = _calculateOffsetLeft(offset, realQuery, provider);
    return Positioned(
      top: top,
      left: left,
      child: ScalableScreen(
        base: widget.child,
        child: child,
        mediaQueryData: provider.boundedMediaQuery,
        scale: provider.screenScale,
        label: label,
        routeName: routeName,
      ),
    );
  }

  Positioned _addSectionStart({
    @required MaterialApp base,
    Offset offset = Offset.zero,
    String label,
    @required MediaQueryData realQuery,
    @required OverrideMediaQueryProvider provider,
  }) {
    final top = _calculateOffsetTop(offset, realQuery, provider);
    final left = _calculateOffsetLeft(offset, realQuery, provider);
    return Positioned(
      top: top,
      left: left,
      child: ScalableScreen(
        base: widget.child,
        child: FlowStart(label: label),
        mediaQueryData: provider.boundedMediaQuery,
        scale: provider.screenScale,
        label: label,
      ),
    );
  }

  _renderRoutes(OverrideMediaQueryProvider provider, MediaQueryData realQuery) {
    final List<Widget> routesList = [];
    final base = widget.child;
    final _size = provider.boundedMediaQuery.size;
    final mapping = widget.routesMapping;
    if (mapping?.isNotEmpty == true) {
      var index = 0;
      mapping.entries.forEach((entry) {
        var offsetIndex = 0;
        routesList.add(_addSectionStart(
          provider: provider,
          realQuery: realQuery,
          base: base,
          offset: Offset((_size.width + _kSpacing) * (offsetIndex),
              ((_size.height + _kSpacing) + 40) * index),
          label: entry.key,
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

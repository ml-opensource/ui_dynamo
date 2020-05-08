import 'package:flutter/material.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/storyboard/flow_start.dart';
import 'package:flutter_storybook/ui/storyboard/screen.dart';
import 'package:flutter_storybook/ui/storyboard/storyboard_toolbar.dart';
import 'package:flutter_storybook/ui/storyboard/utils.dart';

const _kSpacing = 80.0;

class StoryBoard extends StatefulWidget {
  /// Wrap your Material App with this widget
  final MaterialApp child;

  /// You can disable this widget at any time and just return the child
  final bool enabled;

  /// Initial Offset of the canvas
  final Offset initialOffset;

  /// Initial Scale of the canvas
  final double initialScale;

  final Map<String, List<String>> routesMapping;

  const StoryBoard({
    Key key,
    @required this.child,
    this.enabled = true,
    this.initialOffset,
    this.initialScale,
    this.routesMapping,
  }) : super(key: key);

  @override
  StoryboardController createState() => StoryboardController();
}

class StoryboardController extends State<StoryBoard> {
  double _scale;
  Offset _offset;

  @override
  void initState() {
    _scale = widget.initialScale;
    _scale ??= 1.0;
    _offset = widget.initialOffset;
    _offset ??= Offset(10, -40);
    super.initState();
  }

  @override
  void didUpdateWidget(StoryBoard oldWidget) {
    if (oldWidget.child != widget.child) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateOffset(Offset value) {
    if (mounted) {
      setState(() {
        _offset += value;
      });
    }
  }

  void _updateScale(double value) {
    if (mounted) {
      setState(() {
        _scale = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = mediaQuery(context);
    final mediaQueryData = query.boundedMediaQuery;
    final base = widget.child;
    final _size = mediaQueryData.size;
    if (!widget.enabled) return base;
    return Stack(
      children: [
        Scaffold(
          body: GestureDetector(
            onPanUpdate: (panDetails) => _updateOffset(panDetails.delta),
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
                        base,
                        mediaQueryData,
                        base.home,
                        '/',
                        false,
                        false,
                        Offset(0, 10),
                        'Home',
                      ),
                    if (base?.initialRoute != null &&
                        widget.routesMapping == null)
                      _addChild(
                        base,
                        mediaQueryData,
                        base.routes[base.initialRoute](context),
                        base.initialRoute,
                        false,
                        false,
                        Offset(base?.home != null ? _size.width + _kSpacing : 0,
                            10),
                        'Initial Route',
                      ),
                    ..._renderRoutes(mediaQueryData),
                  ],
                ),
              ),
            ),
          ),
        ),
        StoryboardToolbar(
          scale: _scale,
          updateScale: _updateScale,
        ),
      ],
    );
  }

  Positioned _addChild(
    MaterialApp base,
    MediaQueryData mediaQueryData,
    Widget child,
    String routeName,
    bool isFirst,
    bool isLast, [
    Offset offset = Offset.zero,
    String label,
  ]) {
    return Positioned(
      top: calculateTop(offset, _offset, _scale),
      left: calculateLeft(offset, _offset, _scale),
      child: StoryboardScreen(
        base: widget.child,
        child: child,
        offset: offset,
        mediaQueryData: mediaQueryData,
        scale: _scale,
        label: label,
        routeName: routeName,
        isFirst: isFirst,
        isLast: isLast,
      ),
    );
  }

  Positioned _addSectionStart(MaterialApp base, MediaQueryData mediaQueryData,
      [Offset offset = Offset.zero, String label]) {
    return Positioned(
      top: calculateTop(offset, _offset, _scale),
      left: calculateLeft(offset, _offset, _scale),
      child: StoryboardScreen(
        base: widget.child,
        isFirst: true,
        isLast: false,
        child: FlowStart(label: label),
        offset: offset,
        mediaQueryData: mediaQueryData,
        scale: _scale,
        label: label,
      ),
    );
  }

  _renderRoutes(MediaQueryData mediaQueryData) {
    final List<Widget> routesList = [];
    final base = widget.child;
    final _size = mediaQueryData.size;
    final mapping = widget.routesMapping;
    if (mapping?.isNotEmpty == true) {
      var index = 0;
      mapping.entries.forEach((entry) {
        var offsetIndex = 0;
        routesList.add(_addSectionStart(
          base,
          mediaQueryData,
          Offset((_size.width + _kSpacing) * (offsetIndex),
              ((_size.height + _kSpacing) + 40) * index),
          entry.key,
        ));
        entry.value.forEach((route) {
          final currentRoute = base.routes[route];
          assert(() {
            if (currentRoute == null) {
              throw FlutterError(
                  "Could not find a route mapping for ${route} in application routes");
            }
            return true;
          }());
          routesList.add(_addChild(
            base,
            mediaQueryData,
            currentRoute(context),
            route,
            false,
            (offsetIndex == entry.value.length - 1),
            Offset((_size.width + _kSpacing) * (offsetIndex + 1),
                ((_size.height + _kSpacing) + 40) * index),
            route,
          ));
          offsetIndex++;
        });
        index++;
      });
    } else if (base?.routes != null) {
      for (var r = 0; r < base.routes.keys.length; r++) {
        routesList.add(_addChild(
          base,
          mediaQueryData,
          base.routes[base.routes.keys.toList()[r]](context),
          base.routes.keys.toList()[r],
          false,
          false,
          Offset(
              (_size.width + _kSpacing) * r, (_size.height + _kSpacing) + 40),
          base.routes.keys.toList()[r],
        ));
      }
    }
    return routesList;
  }
}

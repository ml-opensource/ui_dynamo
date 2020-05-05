import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/ui/utils/hold_detector.dart';
import 'package:flutter_storybook/ui/widgets/size+extensions.dart';
import 'package:flutter_storybook/ui/widgets/storyboard/screen.dart';
import 'package:flutter_storybook/ui/widgets/storyboard/utils.dart';

const _kSpacing = 80.0;

StoryBookPage storyboard(MaterialApp app,
    {@required String title, Map<String, List<String>> routesMapping}) {
  final page = StoryBookPage(
    key: ValueKey(title),
    title: Text(title),
    widget: StoryBookWidget((context, data) => StoryBoard(
          child: app,
          mediaQueryData: data.copyWith(
            size: data.size.boundedSize(context),
          ),
          enabled: true,
          routesMapping: routesMapping,
        )),
  );
  // disable scrolling since our storyboard will handle it for us!
  page.shouldScroll = false;
  page.usesToolbar = false;
  return page;
}

class StoryBoard extends StatefulWidget {
  /// Wrap your Material App with this widget
  final MaterialApp child;

  /// current media query to use.
  final MediaQueryData mediaQueryData;

  /// You can disable this widget at any time and just return the child
  final bool enabled;

  /// Initial Offset of the canvas
  final Offset initialOffset;

  /// Callback for when the canvas offset changes
  final ValueChanged<Offset> offsetChanged;

  /// Initial Scale of the canvas
  final double initialScale;

  /// Callback for when the scale of the canvas changes
  final ValueChanged<double> scaleChanged;

  final Map<String, List<String>> routesMapping;

  const StoryBoard({
    Key key,
    @required this.child,
    this.enabled = true,
    this.mediaQueryData,
    this.initialOffset,
    this.offsetChanged,
    this.initialScale,
    this.scaleChanged,
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

  @override
  Widget build(BuildContext context) {
    final base = widget.child;
    final _size = widget.mediaQueryData.size;
    if (!widget.enabled) return base;
    return Stack(
      children: [
        Scaffold(
          body: GestureDetector(
            onPanUpdate: (panDetails) => updateOffset(panDetails.delta),
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
                        base.routes[base.initialRoute](context),
                        base.initialRoute,
                        false,
                        false,
                        Offset(base?.home != null ? _size.width + _kSpacing : 0,
                            10),
                        'Initial Route',
                      ),
                    ..._renderRoutes(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                HoldDetector(
                  holdTimeout: Duration(milliseconds: 200),
                  enableHapticFeedback: true,
                  onHold: () => updateScale(_scale - 0.05),
                  child: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => updateScale(_scale - 0.05),
                  ),
                ),
                InkWell(
                  child: Center(child: Text('${(_scale * 100).round()}%')),
                  onTap: () => updateScale(1),
                ),
                HoldDetector(
                  holdTimeout: Duration(milliseconds: 200),
                  enableHapticFeedback: true,
                  onHold: () => updateScale(_scale + 0.05),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => updateScale(_scale + 0.05),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Positioned _addChild(
    MaterialApp base,
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
        mediaQueryData: widget.mediaQueryData,
        scale: _scale,
        label: label,
        routeName: routeName,
        isFirst: isFirst,
        isLast: isLast,
      ),
    );
  }

  Positioned _addSectionStart(MaterialApp base,
      [Offset offset = Offset.zero, String label]) {
    return Positioned(
      top: calculateTop(offset, _offset, _scale),
      left: calculateLeft(offset, _offset, _scale),
      child: StoryboardScreen(
        base: widget.child,
        isFirst: true,
        isLast: false,
        child: Material(
          child: Container(
            color: Colors.black,
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 34.0,
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Flow'),
                    Text(label),
                  ],
                ),
              ),
            ),
          ),
        ),
        offset: offset,
        mediaQueryData: widget.mediaQueryData,
        scale: _scale,
        label: label,
      ),
    );
  }

  _renderRoutes() {
    final List<Widget> routesList = [];
    final base = widget.child;
    final _size = widget.mediaQueryData.size;
    final mapping = widget.routesMapping;
    if (mapping?.isNotEmpty == true) {
      var index = 0;
      mapping.entries.forEach((entry) {
        var offsetIndex = 0;
        routesList.add(_addSectionStart(
          base,
          Offset((_size.width + _kSpacing) * (offsetIndex),
              ((_size.height + _kSpacing) + 40) * index),
          entry.key,
        ));
        entry.value.forEach((route) {
          routesList.add(_addChild(
            base,
            base.routes[route](context),
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

  void updateOffset(Offset value) {
    if (mounted)
      setState(() {
        _offset += value;
      });
    if (widget?.offsetChanged != null) {
      widget.offsetChanged(_offset);
    }
  }

  void updateScale(double value) {
    if (mounted)
      setState(() {
        _scale = value;
      });
    if (widget?.scaleChanged != null) {
      widget.scaleChanged(_scale);
    }
  }
}

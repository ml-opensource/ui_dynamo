import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

const _kSpacing = 40.0;

StoryBookPage storyboard(MaterialApp app, {@required String title}) {
  final page = StoryBookPage(
    key: ValueKey(title),
    title: Text(title),
    widget: StoryBookWidget((context, data) => StoryBoard(
          child: app,
          screenSize: data.size,
          enabled: true,
        )),
  );
  // disable scrolling since our storyboard will handle it for us!
  page.shouldScroll = false;
  return page;
}

class StoryBoard extends StatefulWidget {
  /// Wrap your Material App with this widget
  final MaterialApp child;

  /// Size for each screen
  final Size screenSize;

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

  const StoryBoard({
    Key key,
    @required this.child,
    this.enabled = true,
    this.screenSize = const Size(400, 700),
    this.initialOffset,
    this.offsetChanged,
    this.initialScale,
    this.scaleChanged,
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
    _scale ??= 0.75;
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
    final _size = widget.screenSize;
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
                    if (base?.home != null)
                      _addChild(
                        base,
                        base.home,
                        Offset(0, 10),
                        'Home',
                      ),
                    if (base?.initialRoute != null)
                      _addChild(
                        base,
                        base.routes[base.initialRoute](context),
                        Offset(base?.home != null ? _size.width + _kSpacing : 0,
                            10),
                        'Initial Route',
                      ),
                    if (base?.routes != null) ...[
                      for (var r = 0; r < base.routes.keys.length; r++)
                        _addChild(
                          base,
                          base.routes[base.routes.keys.toList()[r]](context),
                          Offset((_size.width + _kSpacing) * r,
                              (_size.height + _kSpacing) + 40),
                          base.routes.keys.toList()[r],
                        ),
                    ]
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
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => updateScale(_scale - 0.01),
                ),
                InkWell(
                  child: Center(child: Text('${(_scale * 100).round()}%')),
                  onTap: () => updateScale(1),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => updateScale(_scale + 0.01),
                ),
              ],
            ),
          ],
        ),
      ],
    );
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

  Positioned _addChild(MaterialApp base, Widget child,
      [Offset offset = Offset.zero, String label]) {
    final _top = _offset.dy + (_scale * offset.dy);
    final _left = _offset.dx + (_scale * offset.dx);
    final base = widget.child;
    final _size = widget.screenSize;
    return Positioned(
      top: _top,
      left: _left,
      child: Transform.scale(
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _size.width,
              height: _size.height,
              child: Material(
                elevation: 4,
                child: ClipRect(
                  clipper: CustomRect(Offset(0, 0)),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    routes: base.routes,
                    onGenerateRoute: base.onGenerateRoute,
                    onGenerateInitialRoutes: base.onGenerateInitialRoutes,
                    onUnknownRoute: base.onUnknownRoute,
                    themeMode: base.themeMode,
                    theme: base.theme,
                    darkTheme: base.darkTheme,
                    // patch when you use a home route with /, dont use child
                    home: child,
                  ),
                ),
              ),
            ),
            if (label != null) Center(child: _addLabel(label)),
          ],
        ),
      ),
    );
  }

  Widget _addLabel(String label) => Container(
        margin: EdgeInsetsDirectional.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
}

class CustomRect extends CustomClipper<Rect> {
  final Offset offset;

  CustomRect(this.offset);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/widgets/storyboard/custom_rect.dart';
import 'package:flutter_storybook/ui/widgets/storyboard/label.dart';

class StoryboardScreen extends StatelessWidget {
  final double scale;
  final Offset offset;
  final MaterialApp base;
  final Size screenSize;
  final String label;
  final Widget child;
  final String routeName;

  const StoryboardScreen({
    Key key,
    @required this.scale,
    @required this.offset,
    @required this.base,
    @required this.screenSize,
    this.label,
    @required this.child,
    this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: screenSize.width,
            height: screenSize.height,
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
          if (label != null)
            Center(
                child: StoryBookLabel(
              label: label,
              routeName: routeName,
            )),
        ],
      ),
    );
  }
}

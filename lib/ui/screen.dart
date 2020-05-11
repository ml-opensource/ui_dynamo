import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/storyboard/custom_rect.dart';
import 'package:flutter_storybook/ui/storyboard/label.dart';

class ScalableScreen extends StatelessWidget {
  final double scale;
  final MaterialApp base;
  final MediaQueryData mediaQueryData;
  final String label;
  final Widget child;
  final String routeName;
  final bool isStoryBoard;
  final bool showBorder;

  const ScalableScreen({
    Key key,
    @required this.scale,
    @required this.base,
    @required this.mediaQueryData,
    this.label,
    @required this.child,
    this.routeName,
    this.isStoryBoard = true,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              decoration: showBorder
                  ? BoxDecoration(
                      border: Border.all(color: Theme.of(context).accentColor),
                    )
                  : null,
              child: SizedBox(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height,
                child: Material(
                  elevation: 4,
                  child: ClipRect(
                    clipper: CustomRect(Offset(0, 0)),
                    child: base.isolatedCopy(
                      data: mediaQueryData,
                      // patch when you use a home route with /, dont use child
                      home: isStoryBoard
                          ? MediaQuery(
                              child: child,
                              data: mediaQueryData,
                            )
                          : child,
                    ),
                  ),
                ),
              )),
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

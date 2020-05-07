import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/widgets/storyboard/custom_rect.dart';
import 'package:flutter_storybook/ui/widgets/storyboard/label.dart';

class StoryboardScreen extends StatelessWidget {
  final double scale;
  final Offset offset;
  final MaterialApp base;
  final MediaQueryData mediaQueryData;
  final String label;
  final Widget child;
  final String routeName;
  final bool isFirst;
  final bool isLast;

  const StoryboardScreen({
    Key key,
    @required this.scale,
    @required this.offset,
    @required this.base,
    @required this.mediaQueryData,
    this.label,
    @required this.child,
    this.routeName,
    this.isFirst,
    this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: mediaQueryData.size.width,
            height: mediaQueryData.size.height,
            child: Material(
              elevation: 4,
              child: ClipRect(
                clipper: CustomRect(Offset(0, 0)),
                child: base.isolatedCopy(
                  data: mediaQueryData,
                  // patch when you use a home route with /, dont use child
                  home: MediaQuery(
                    child: child,
                    data: mediaQueryData,
                  ),
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

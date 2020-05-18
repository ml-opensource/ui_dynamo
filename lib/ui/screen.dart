import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/storyboard/custom_rect.dart';
import 'package:flutter_storybook/ui/storyboard/label.dart';

class ScalableScreen extends StatelessWidget {
  final MaterialApp base;
  final String label;
  final Widget child;
  final String routeName;
  final bool isStoryBoard;
  final bool isFlowStart;
  final bool showBorder;
  final OverrideMediaQueryProvider provider;

  const ScalableScreen({
    Key key,
    @required this.provider,
    @required this.base,
    this.label,
    @required this.child,
    this.routeName,
    this.isStoryBoard = true,
    this.showBorder = true,
    this.isFlowStart = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = provider.boundedMediaQuery;
    return Transform.scale(
      scale: provider.screenScale,
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
                width: provider.viewportWidth,
                height: provider.viewportHeight,
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
              isFlowStart: isFlowStart,
              label: label,
              routeName: routeName,
            )),
        ],
      ),
    );
  }
}

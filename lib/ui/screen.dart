import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/localization/localizations_plugin.dart';
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
  final double screenScale;
  final Size viewPortSize;
  final MediaQueryData boundedMediaQuery;

  const ScalableScreen({
    Key key,
    @required this.base,
    this.label,
    @required this.child,
    this.routeName,
    this.isStoryBoard = true,
    this.showBorder = true,
    this.isFlowStart = false,
    @required this.screenScale,
    @required this.viewPortSize,
    @required this.boundedMediaQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = boundedMediaQuery;
    final localizations = context.locales;
    return Transform.scale(
      scale: screenScale,
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
                width: viewPortSize.width,
                height: viewPortSize.height,
                child: _IsolatedCopy(
                    base: base,
                    mediaQueryData: mediaQueryData,
                    isStoryBoard: isStoryBoard,
                    overrideLocale: localizations.overrideLocale,
                    supportedLocales: localizations.supportedLocales,
                    child: child),
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

class _IsolatedCopy extends StatelessWidget {
  final MaterialApp base;
  final MediaQueryData mediaQueryData;
  final bool isStoryBoard;
  final Locale overrideLocale;
  final List<Locale> supportedLocales;
  final Widget child;

  const _IsolatedCopy(
      {Key key,
      @required this.base,
      @required this.mediaQueryData,
      @required this.isStoryBoard,
      @required this.overrideLocale,
      @required this.supportedLocales,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: ClipRect(
        clipper: CustomRect(Offset(0, 0)),
        child: base.isolatedCopy(
          context,
          data: mediaQueryData,
          // patch when you use a home route with /, dont use child
          home: isStoryBoard
              ? MediaQuery(
                  child: child,
                  data: mediaQueryData,
                )
              : child,
          overrideLocale: overrideLocale,
          supportedLocales: supportedLocales,
        ),
      ),
    );
  }
}

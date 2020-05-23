import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/media_query_toolbar.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/interactable_screen.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/model/widget.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';

class StoryBookPageWrapper extends StatefulWidget {
  final StorybookWidgetBuilder builder;
  final bool shouldScroll;
  final MaterialApp base;

  const StoryBookPageWrapper(
      {Key key,
      @required this.builder,
      this.shouldScroll = true,
      @required this.base})
      : super(key: key);

  factory StoryBookPageWrapper.mediaQuery(
          {WidgetBuilder builder, MaterialApp base}) =>
      StoryBookPageWrapper(
        builder: (context, data, app) =>
            MediaQuery(data: data, child: builder(context)),
        base: base,
      );

  @override
  _StoryBookPageWrapperState createState() => _StoryBookPageWrapperState();
}

String deviceDisplay(
  BuildContext context,
  DeviceInfo deviceInfo, {
  bool shortName = false,
}) {
  if (shortName) {
    return deviceInfo.name;
  }
  final boundedSize = deviceInfo.pixelSize.boundedSize(context);
  return "${deviceInfo.name} (${boundedSize.width.truncate()}x${boundedSize.height.truncate()})";
}

class _StoryBookPageWrapperState extends State<StoryBookPageWrapper> {
  @override
  Widget build(BuildContext context) {
    final query = context.mediaQueryProvider;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              !widget.shouldScroll
                  ? widget.base.isolatedCopy(
                      home: widget.builder(
                          context, query.currentMediaQuery, widget.base),
                      data: query.currentMediaQuery,
                    )
                  : InteractableScreen(widget: widget),
              buildMediaQueryToolbar(context, query),
            ],
          ),
        ),
      ],
    );
  }

  buildMediaQueryToolbar(
          BuildContext context, OverrideMediaQueryProvider provider) =>
      MediaQueryToolbar();
}

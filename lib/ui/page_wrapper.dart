import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/localization/localizations_plugin.dart';
import 'package:ui_dynamo/mediaquery/device_sizes.dart';
import 'package:ui_dynamo/mediaquery/media_query_toolbar.dart';
import 'package:ui_dynamo/mediaquery/override_media_query_plugin.dart';
import 'package:ui_dynamo/ui/interactable_screen.dart';
import 'package:ui_dynamo/ui/materialapp+extensions.dart';
import 'package:ui_dynamo/ui/model/widget.dart';
import 'package:ui_dynamo/ui/utils/size+extensions.dart';
import 'package:ui_dynamo/ui/widgets/measuresize.dart';

class DynamoPageWrapper extends StatefulWidget {
  final DynamoWidgetBuilder builder;
  final bool shouldScroll;
  final MaterialApp base;

  const DynamoPageWrapper(
      {Key key,
      @required this.builder,
      this.shouldScroll = true,
      @required this.base})
      : super(key: key);

  factory DynamoPageWrapper.mediaQuery(
          {WidgetBuilder builder, MaterialApp base}) =>
      DynamoPageWrapper(
        builder: (context, data, app) =>
            MediaQuery(data: data, child: builder(context)),
        base: base,
      );

  @override
  _DynamoPageWrapperState createState() => _DynamoPageWrapperState();
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
  final width =
      context.mediaQueryProvider.viewPortWidthCalculate(boundedSize.width);
  final height =
      context.mediaQueryProvider.viewPortHeightCalculate(boundedSize.height);
  return "${deviceInfo.name} (${width.truncate()}x${height.truncate()})";
}

class _DynamoPageWrapperState extends State<DynamoPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              !widget.shouldScroll
                  ? _NonScrollableScreen(
                      base: widget.base, builder: widget.builder)
                  : InteractableScreen(widget: widget),
              _MediaQueryWrapper(),
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaQueryWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.mediaQueryProvider;
    return MeasureSize(
        onChange: (size) => provider.toolbarHeightChanged(size.height),
        child: MediaQueryToolbar());
  }
}

class _NonScrollableScreen extends StatelessWidget {
  final MaterialApp base;
  final DynamoWidgetBuilder builder;

  const _NonScrollableScreen(
      {Key key, @required this.base, @required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = context.mediaQueryProvider;
    final localizations = context.locales;
    return base.isolatedCopy(
      context,
      home: builder(context, query.currentMediaQuery, base),
      data: query.currentMediaQuery,
      overrideLocale: localizations.overrideLocale,
      supportedLocales: localizations.supportedLocales,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/media_query_toolbar.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/utils/measuresize.dart';
import 'package:flutter_storybook/ui/widgets/size+extensions.dart';

typedef MediaWidgetBuilder = Widget Function(BuildContext, MediaQueryData);

class MediaQueryChooser extends StatefulWidget {
  final MediaWidgetBuilder builder;
  final bool shouldScroll;
  final MaterialApp base;

  const MediaQueryChooser(
      {Key key,
      @required this.builder,
      this.shouldScroll = true,
      @required this.base})
      : super(key: key);

  factory MediaQueryChooser.mediaQuery(
          {WidgetBuilder builder, MaterialApp base}) =>
      MediaQueryChooser(
        builder: (context, data) =>
            MediaQuery(data: data, child: builder(context)),
        base: base,
      );

  @override
  _MediaQueryChooserState createState() => _MediaQueryChooserState();
}

String deviceDisplay(BuildContext context, DeviceInfo deviceInfo) {
  final boundedSize = deviceInfo.size.boundedSize(context);
  return "${deviceInfo.name} (${boundedSize.width.truncate()}x${boundedSize.height.truncate()})";
}

class _MediaQueryChooserState extends State<MediaQueryChooser> {
  MediaQueryData currentMediaQuery;
  DeviceInfo currentDeviceSelected = deviceSizes[0];
  double toolbarHeight = 0;

  void _toolbarSizeChanged(Size size) {
    setState(() {
      toolbarHeight = size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentMediaQuery == null) {
      currentMediaQuery =
          MediaQuery.of(context).copyWith(size: currentDeviceSelected.size);
    }

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        !widget.shouldScroll
            ? widget.base.isolatedCopy(
                home: widget.builder(context, currentMediaQuery))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Theme.of(context).accentColor),
                    ),
                    margin: EdgeInsets.only(top: toolbarHeight),
                    constraints: BoxConstraints.tight(
                        currentMediaQuery.size.boundedSize(context)),
                    child: widget.base.isolatedCopy(
                        home: widget.builder(context, currentMediaQuery)),
                  ),
                ),
              ),
        buildMediaQueryToolbar(context),
      ],
    );
  }

  buildMediaQueryToolbar(BuildContext context) => MeasureSize(
        onChange: _toolbarSizeChanged,
        child: MediaQueryToolbar(
          currentDeviceSelected: currentDeviceSelected,
          currentMediaQuery: currentMediaQuery,
          onDeviceInfoChanged: (info) {
            setState(() {
              currentDeviceSelected = info;
            });
          },
          onMediaQueryChange: (query) {
            setState(() {
              currentMediaQuery = query;
            });
          },
        ),
      );
}

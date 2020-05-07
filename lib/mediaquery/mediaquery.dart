import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/media_query_toolbar.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/utils/measuresize.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';

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
  final boundedSize = deviceInfo.pixelSize.boundedSize(context);
  return "${deviceInfo.name} (${boundedSize.width.truncate()}x${boundedSize.height.truncate()})";
}

class _MediaQueryChooserState extends State<MediaQueryChooser> {
  double toolbarHeight = 0;

  void _toolbarSizeChanged(Size size) {
    setState(() {
      toolbarHeight = size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = mediaQuery(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              !widget.shouldScroll
                  ? widget.base.isolatedCopy(
                      home: widget.builder(context, query.currentMediaQuery),
                      data: query.currentMediaQuery,
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).accentColor),
                          ),
                          margin: EdgeInsets.only(top: toolbarHeight + 16),
                          constraints: BoxConstraints.tight(
                              query.boundedMediaQuery.size),
                          child: widget.base.isolatedCopy(
                              data: query.currentMediaQuery,
                              home: widget.builder(
                                  context, query.currentMediaQuery)),
                        ),
                      ),
                    ),
              buildMediaQueryToolbar(context),
            ],
          ),
        ),
      ],
    );
  }

  buildMediaQueryToolbar(BuildContext context) {
    final query = mediaQuery(context);
    return MeasureSize(
      onChange: _toolbarSizeChanged,
      child: MediaQueryToolbar(
        currentDeviceSelected: query.currentDevice,
        currentMediaQuery: query.currentMediaQuery,
        onDeviceInfoChanged: query.selectCurrentDevice,
        onMediaQueryChange: query.selectMediaQuery,
      ),
    );
  }
}

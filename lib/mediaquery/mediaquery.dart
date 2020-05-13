import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/media_query_toolbar.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/screen.dart';
import 'package:flutter_storybook/ui/storyboard/utils.dart';
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

class _MediaQueryChooserState extends State<MediaQueryChooser> {
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
                  : InteractableScreen(
                      toolbarHeight: query.toolbarHeight, widget: widget),
              buildMediaQueryToolbar(context, query),
            ],
          ),
        ),
      ],
    );
  }

  buildMediaQueryToolbar(
          BuildContext context, OverrideMediaQueryProvider provider) =>
      MeasureSize(
        onChange: (size) => provider.toolbarHeightChanged(size.height),
        child: MediaQueryToolbar(),
      );
}

class InteractableScreen extends StatefulWidget {
  const InteractableScreen({
    Key key,
    @required this.toolbarHeight,
    @required this.widget,
  }) : super(key: key);

  final double toolbarHeight;
  final MediaQueryChooser widget;

  @override
  _InteractableScreenState createState() => _InteractableScreenState();
}

class _InteractableScreenState extends State<InteractableScreen> {
  Size offsetLabelSize = Size.zero;

  double _calculateOffsetTop(MediaQueryData realQuery,
      OverrideMediaQueryProvider provider, double toolbarOffset) {
    final offsetTop = Offset(
        0,
        (realQuery.size.height - provider.boundedMediaQuery.size.height) / 2 -
            toolbarOffset);
    return calculateTop(offsetTop, provider.currentOffset, 1.0, bounded: true);
  }

  double _calculateOffsetLeft(
      MediaQueryData realQuery, OverrideMediaQueryProvider provider) {
    final offsetLeft = Offset(
        (realQuery.size.width - provider.boundedMediaQuery.size.width) / 2, 0);
    return calculateLeft(offsetLeft, provider.currentOffset, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final query = mediaQuery(context);
    final realQuery = MediaQuery.of(context);
    final toolbarOffset = (widget.toolbarHeight + 48);
    double topCalculated;
    double leftCalculated;
    // if window, move back to center and do not allow panning.
    if (query.currentDevice == DeviceSizes.window) {
      topCalculated = 0;
      leftCalculated = 0;
    } else {
      topCalculated = _calculateOffsetTop(realQuery, query, toolbarOffset);
      leftCalculated = _calculateOffsetLeft(realQuery, query);
    }
    return GestureDetector(
      onPanUpdate: (panDetails) => query.offsetChange(panDetails.delta),
      behavior: HitTestBehavior.opaque,
      child: OverflowBox(
        child: Container(
          margin: EdgeInsets.only(top: toolbarOffset),
          child: Stack(
            children: [
              Positioned(
                top: topCalculated,
                left: leftCalculated,
                child: Stack(
                  children: [
                    ScalableScreen(
                      showBorder: query.currentDevice != DeviceSizes.window,
                      isStoryBoard: false,
                      scale: query.screenScale,
                      mediaQueryData: query.boundedMediaQuery,
                      base: widget.widget.base,
                      child: widget.widget
                          .builder(context, query.currentMediaQuery),
                    ),
                    if (query.showOffsetIndicator)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: MeasureSize(
                          onChange: (size) {
                            setState(() {
                              this.offsetLabelSize = size;
                            });
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Offset (${leftCalculated.truncateToDouble()},${topCalculated.truncateToDouble()})"),
                          )),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

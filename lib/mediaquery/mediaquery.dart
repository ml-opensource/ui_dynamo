import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/media_query_toolbar.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/screen.dart';
import 'package:flutter_storybook/ui/storyboard/utils.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';
import 'package:flutter_storybook/ui/widgets/measuresize.dart';
import 'package:flutter_storybook/ui/widgets/panscroll.dart';
import 'package:rxdart/rxdart.dart';

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
      MeasureSize(
        onChange: (size) => provider.toolbarHeightChanged(size.height),
        child: MediaQueryToolbar(),
      );
}

class InteractableScreen extends StatefulWidget {
  const InteractableScreen({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final MediaQueryChooser widget;

  @override
  _InteractableScreenState createState() => _InteractableScreenState();
}

class OffsetScrollEvent {
  final Offset offset;
  final bool isScrolling;

  OffsetScrollEvent(this.offset, this.isScrolling);

  @override
  String toString() {
    return 'OffsetScrollEvent{offset: $offset, isScrolling: $isScrolling}';
  }
}

class _InteractableScreenState extends State<InteractableScreen> {
  Size offsetLabelSize = Size.zero;
  final _isScrolling = BehaviorSubject.seeded(false);
  final _notScrollingThrottle = PublishSubject();
  final _scrollOffsetChange = PublishSubject<Offset>();

  CompositeSubscription _subscription = CompositeSubscription();

  double _calculateOffsetTop(
      MediaQueryData realQuery, OverrideMediaQueryProvider provider) {
    final offsetTop = Offset(
        0,
        (realQuery.size.height -
                provider.boundedMediaQuery.size.height - provider.toolbarHeight) /
            2);
    return calculateTop(offsetTop, provider.currentOffset, 1.0);
  }

  double _calculateOffsetLeft(
      MediaQueryData realQuery, OverrideMediaQueryProvider provider) {
    final offsetLeft = Offset(
        (realQuery.size.width - provider.boundedMediaQuery.size.width) / 2, 0);
    return calculateLeft(offsetLeft, provider.currentOffset, 1.0);
  }

  @override
  void initState() {
    super.initState();
    CombineLatestStream.combine2(
      _scrollOffsetChange.distinct(),
      _isScrolling.distinct(),
      (offset, isScrolling) => OffsetScrollEvent(offset, isScrolling),
    ).where((event) => !event.isScrolling).listen((event) {
      if (event.offset != null && !event.isScrolling) {
        final query = mediaQuery(context);
        query.offsetChange(event.offset);
      }
    }).addTo(_subscription);
    _notScrollingThrottle
        .throttleTime(Duration(milliseconds: 1000), trailing: true)
        .listen((event) {
      _isScrolling.add(false);
    }).addTo(_subscription);
    _isScrolling.add(false);
  }

  @override
  void deactivate() {
    _subscription.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final query = mediaQuery(context);
    final realQuery = MediaQuery.of(context);
    // if window, move back to center and do not allow panning.
    final widthSmaller = query.scaledWidth < realQuery.size.width;
    final heightSmaller = query.scaledHeight <
        query.viewPortHeightCalculate(realQuery.size.height);
    final isWindow = query.currentDevice == DeviceSizes.window;
    double topCalculated =
        isWindow ? query.toolbarHeight : _calculateOffsetTop(realQuery, query);
    double leftCalculated =
        isWindow ? 0 : _calculateOffsetLeft(realQuery, query);
    return NotificationListener<ScrollNotification>(
      onNotification: _sendScrollNotification,
      child: PanScrollDetector(
        isHorizontalEnabled: !widthSmaller && !isWindow && heightSmaller,
        isVerticalEnabled: !heightSmaller && !isWindow && widthSmaller,
        isPanningEnabled: !heightSmaller && !widthSmaller && !isWindow,
        onOffsetChange: (offset) => _sendOffsetNotification(query, offset),
        child: OverflowBox(
          child: Stack(
            children: [
              Positioned(
                top: topCalculated,
                left: leftCalculated,
                child: SizedBox(
                  width: query.viewportWidth + 2,
                  height: query.viewportHeight + 2,
                  child: Stack(
                    children: [
                      ScalableScreen(
                        showBorder: query.currentDevice != DeviceSizes.window,
                        isStoryBoard: false,
                        provider: query,
                        base: widget.widget.base,
                        child: widget.widget
                            .builder(context, query.currentMediaQuery),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendOffsetNotification(
      OverrideMediaQueryProvider query, Offset offset) {
    _scrollOffsetChange.add(offset);
  }

  bool _sendScrollNotification(ScrollNotification scroll) {
    if (scroll is ScrollStartNotification) {
      _isScrolling.add(true);
    } else if (scroll is ScrollEndNotification) {
      _notScrollingThrottle.add(null);
    }
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_storybook/mediaquery/offset_plugin.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_plugin.dart';
import 'package:flutter_storybook/ui/page_wrapper.dart';
import 'package:flutter_storybook/ui/screen.dart';
import 'package:flutter_storybook/ui/storyboard/utils.dart';
import 'package:flutter_storybook/ui/widgets/panscroll.dart';
import 'package:rxdart/rxdart.dart';

class InteractableScreen extends StatefulWidget {
  const InteractableScreen({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final StoryBookPageWrapper widget;

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

  double _calculateOffsetTop(MediaQueryData realQuery,
      OverrideMediaQueryProvider provider, OffsetProvider offsetProvider) {
    return calculateTop(Offset(0, provider.viewPortOffsetTop(realQuery)),
        offsetProvider.currentOffset, 1.0);
  }

  double _calculateOffsetLeft(MediaQueryData realQuery,
      OverrideMediaQueryProvider provider, OffsetProvider offsetProvider) {
    final offsetLeft = Offset(provider.viewPortOffsetLeft(realQuery), 0);
    return calculateLeft(offsetLeft, offsetProvider.currentOffset, 1.0);
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
        context.offsetProvider.offsetChange(event.offset);
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
    final query = context.mediaQueryProvider;
    final offset = context.offsetProvider;
    final realQuery = MediaQuery.of(context);
    // if window, move back to center and do not allow panning.
    final widthSmaller = query.scaledWidth(offset) <=
        query.viewPortWidthCalculate(realQuery.size.width);
    final heightSmaller = query.scaledHeight(offset) <=
        query.viewPortHeightCalculate(realQuery.size.height);
    final isExpandableWidth = query.currentDevice.isExpandableWidth;
    final isExpandableHeight = query.currentDevice.isExpandableHeight;
    double topCalculated = isExpandableHeight
        ? query.toolbarHeight
        : _calculateOffsetTop(realQuery, query, offset);
    double leftCalculated =
        isExpandableWidth ? 0 : _calculateOffsetLeft(realQuery, query, offset);
    return NotificationListener<ScrollNotification>(
      onNotification: _sendScrollNotification,
      child: PanScrollDetector(
        isHorizontalEnabled:
            !widthSmaller && !isExpandableWidth && heightSmaller,
        isVerticalEnabled:
            !heightSmaller && !isExpandableHeight && widthSmaller,
        isPanningEnabled: !heightSmaller &&
            !widthSmaller &&
            !(isExpandableWidth && !isExpandableHeight),
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
                        showBorder: !query.currentDevice.isExpandable,
                        isStoryBoard: false,
                        viewPortSize: query.viewportSize,
                        screenScale: offset.screenScale,
                        boundedMediaQuery: query.boundedMediaQuery,
                        base: widget.widget.base,
                        child: widget.widget.builder(context,
                            query.currentMediaQuery, widget.widget.base),
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

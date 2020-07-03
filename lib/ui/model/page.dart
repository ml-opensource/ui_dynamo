import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/ui_dynamo.dart';
import 'package:ui_dynamo/media_utils.dart';
import 'package:ui_dynamo/ui/model/widget.dart';
import 'package:ui_dynamo/ui/styles/text_styles.dart';

class DynamoPage extends DynamoItem {
  /// Returns the widgets to render in a page. These are loaded when page clicked.
  final DynamoWidget widget;
  bool shouldScroll = true;
  bool usesToolbar = true;

  DynamoPage(
      {@required Key key,
      @required Widget title,
      Icon icon,
      @required this.widget})
      : super(key, title, icon);

  factory DynamoPage.storyboard(
      {@required String title,
      Map<String, List<String>> routesMapping,

      /// supplied to override the default app passed into the storyboard widget
      /// Used to add previewRoutes to the storyboard.
      MaterialApp appOverride}) {
    final page = DynamoPage(
      key: ValueKey(title),
      title: Text(title),
      widget: DynamoWidget((context, data, app) => StoryBoard(
            child: appOverride ?? app,
            routesMapping: routesMapping,
          )),
    );
    // disable scrolling since our storyboard will handle it for us!
    page.shouldScroll = false;
    page.usesToolbar = false;
    return page;
  }

  factory DynamoPage.list({
    Key key,
    @required String title,
    Icon icon,
    @required List<Widget> Function(BuildContext context) widgets,
  }) =>
      DynamoPage(
          key: key ?? ValueKey(title),
          title: Text(title),
          icon: icon,
          widget: DynamoWidgetList(widgets));

  factory DynamoPage.of({
    Key key,
    @required String title,
    Icon icon,
    @required Widget Function(BuildContext context) child,
  }) =>
      DynamoPage(
          key: key ?? ValueKey(title),
          title: Text(title),
          icon: icon,
          widget: DynamoWidget.widgetBuilder(child));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is DynamoPage &&
          runtimeType == other.runtimeType &&
          widget == other.widget;

  @override
  int get hashCode => super.hashCode ^ widget.hashCode;

  @override
  DynamoPage pageFromKey(Key key) => this;

  @override
  Widget buildWidget(DynamoPage selectedPage,
      Function(DynamoItem p1, DynamoPage p2) onSelectPage) {
    return DynamoPageWidget(
      page: this,
      selectedPage: selectedPage,
      onSelectPage: (page) => onSelectPage(page, page),
    );
  }
}

class DynamoPageWidget extends StatelessWidget {
  final DynamoPage page;
  final DynamoPage selectedPage;
  final Function(DynamoPage) onSelectPage;

  const DynamoPageWidget(
      {Key key, @required this.page, this.selectedPage, this.onSelectPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: page.icon ?? Icon(Icons.book),
        title: DefaultTextStyle.merge(
          child: page.title,
          style: context.isWatch ? smallStyle : null,
        ),
        selected: selectedPage != null && selectedPage == page,
        onTap: () => onSelectPage(page),
      );
}

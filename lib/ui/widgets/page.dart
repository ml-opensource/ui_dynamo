import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/widgets/folder.dart';
import 'package:flutter_storybook/ui/widgets/widget.dart';

class StoryBookPage {
  final Key key;
  final Widget title;
  final Icon icon;

  /// Returns the widgets to render in a page. These are loaded when page clicked.
  final StoryBookWidget widget;

  StoryBookPage(
      {@required this.key,
      @required this.title,
      this.icon,
      @required this.widget});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookPage &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          icon == other.icon &&
          widget == other.widget;

  @override
  int get hashCode =>
      key.hashCode ^ title.hashCode ^ icon.hashCode ^ widget.hashCode;

  build(BuildContext context) => widget.childBuilder(context);
}

class StoryBookPageWidget extends StatelessWidget {
  final StoryBookFolder folder;
  final StoryBookPage page;
  final StoryBookPage selectedPage;
  final Function(StoryBookFolder, StoryBookPage) onSelectPage;

  const StoryBookPageWidget(
      {Key key,
      @required this.page,
      this.selectedPage,
      this.onSelectPage,
      @required this.folder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: page.icon ?? Icon(Icons.book),
        title: page.title,
        selected: selectedPage != null && selectedPage == page,
        onTap: () => onSelectPage(folder, page),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/widgets/page.dart';

class StoryBookFolder {
  final Key key;
  final Widget title;
  final Icon icon;

  final List<StoryBookPage> pages;

  StoryBookFolder(
      {@required this.key,
      @required this.title,
      this.pages = const [],
      this.icon});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookFolder &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          icon == other.icon &&
          pages == other.pages;

  @override
  int get hashCode =>
      key.hashCode ^ title.hashCode ^ icon.hashCode ^ pages.hashCode;
}

class StoryBookFolderWidget extends StatelessWidget {
  final StoryBookFolder folder;
  final StoryBookPage selectedPage;
  final Function(StoryBookFolder, StoryBookPage) onSelectPage;

  const StoryBookFolderWidget(
      {Key key,
      @required this.folder,
      this.selectedPage,
      @required this.onSelectPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ExpansionTile(
        leading: folder.icon ?? Icon(Icons.folder),
        title: folder.title,
        initiallyExpanded: folder.pages.contains(selectedPage),
        children: <Widget>[
          ...folder.pages.map((page) => StoryBookPageWidget(
              page: page,
              selectedPage: selectedPage,
              onSelectPage: onSelectPage,
              folder: folder))
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/ui/model/page.dart';
import 'package:flutter_storybook/ui/styles/text_styles.dart';

class StoryBookFolder extends StoryBookItem {
  final List<StoryBookPage> pages;

  StoryBookFolder(
      {@required Key key,
      @required Widget title,
      this.pages = const [],
      Icon icon})
      : super(key, title, icon);

  factory StoryBookFolder.of({
    Key key,
    String title,
    @required List<StoryBookPage> pages,
  }) =>
      StoryBookFolder(
        key: key ?? ValueKey(title),
        title: Text(title),
        pages: pages,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is StoryBookFolder &&
          runtimeType == other.runtimeType &&
          pages == other.pages;

  @override
  int get hashCode => super.hashCode ^ pages.hashCode;

  @override
  StoryBookPage pageFromKey(Key key) =>
      pages.firstWhere((element) => element.key == key, orElse: () => null);

  @override
  Widget buildWidget(StoryBookPage selectedPage,
          Function(StoryBookItem p1, StoryBookPage p2) onSelectPage) =>
      StoryBookFolderWidget(
        folder: this,
        selectedPage: selectedPage,
        onSelectPage: onSelectPage,
      );
}

class StoryBookFolderWidget extends StatelessWidget {
  final StoryBookFolder folder;
  final StoryBookPage selectedPage;
  final Function(StoryBookItem, StoryBookPage) onSelectPage;

  const StoryBookFolderWidget(
      {Key key,
      @required this.folder,
      this.selectedPage,
      @required this.onSelectPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ExpansionTile(
        leading: folder.icon ?? Icon(Icons.folder),
        title: DefaultTextStyle.merge(
          child: folder.title,
          style: context.isWatch ? smallStyle : null,
        ),
        initiallyExpanded: folder.pages.contains(selectedPage),
        children: <Widget>[
          ...folder.pages.map((page) => StoryBookPageWidget(
                page: page,
                selectedPage: selectedPage,
                onSelectPage: (page) => onSelectPage(folder, page),
              ))
        ],
      );
}

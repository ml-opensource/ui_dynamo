import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/media_utils.dart';
import 'package:ui_dynamo/models.dart';
import 'package:ui_dynamo/ui/model/page.dart';
import 'package:ui_dynamo/ui/styles/text_styles.dart';

class DynamoFolder extends DynamoItem {
  final List<DynamoPage> pages;

  DynamoFolder(
      {@required Key key,
      @required Widget title,
      this.pages = const [],
      Icon icon})
      : super(key, title, icon);

  factory DynamoFolder.of({
    Key key,
    String title,
    @required List<DynamoPage> pages,
  }) =>
      DynamoFolder(
        key: key ?? ValueKey(title),
        title: Text(title),
        pages: pages,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is DynamoFolder &&
          runtimeType == other.runtimeType &&
          pages == other.pages;

  @override
  int get hashCode => super.hashCode ^ pages.hashCode;

  @override
  DynamoPage pageFromKey(Key key) =>
      pages.firstWhere((element) => element.key == key, orElse: () => null);

  @override
  Widget buildWidget(DynamoPage selectedPage,
          Function(DynamoItem p1, DynamoPage p2) onSelectPage) =>
      DynamoFolderWidget(
        folder: this,
        selectedPage: selectedPage,
        onSelectPage: onSelectPage,
      );
}

class DynamoFolderWidget extends StatelessWidget {
  final DynamoFolder folder;
  final DynamoPage selectedPage;
  final Function(DynamoItem, DynamoPage) onSelectPage;

  const DynamoFolderWidget(
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
          ...folder.pages.map((page) => DynamoPageWidget(
                page: page,
                selectedPage: selectedPage,
                onSelectPage: (page) => onSelectPage(folder, page),
              ))
        ],
      );
}

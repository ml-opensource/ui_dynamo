import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models.dart';

class StoryBookDrawer extends StatelessWidget {
  final StoryBookData data;
  final Function(StoryBookFolder, StoryBookPage) onSelectPage;
  final StoryBookPage selectedPage;

  const StoryBookDrawer({
    Key key,
    @required this.data,
    @required this.onSelectPage,
    @required this.selectedPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: DefaultTextStyle(
              child: data.title,
              style: TextStyle(fontSize: 20),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ...data.folders.map((folder) => ExpansionTile(
                leading: folder.icon ?? Icon(Icons.folder),
                title: folder.title,
                initiallyExpanded: folder.pages.contains(selectedPage),
                children: <Widget>[
                  ...folder.pages.map((page) => ListTile(
                        leading: page.icon ?? Icon(Icons.book),
                        title: page.title,
                        selected: selectedPage != null && selectedPage == page,
                        onTap: () {
                          onSelectPage(folder, page);
                        },
                      ))
                ],
              ))
        ],
      ),
    );
  }
}

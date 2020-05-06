import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/widgets/page.dart';

import '../models.dart';

class StoryBookDrawer extends StatelessWidget {
  final StoryBookData data;
  final Function(StoryBookItem, StoryBookPage) onSelectPage;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            child: DefaultTextStyle.merge(
              child: data.title,
              style: TextStyle(fontSize: 20),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
              ),
              itemCount: data.items.length,
              itemBuilder: (context, index) =>
                  data.items[index].buildWidget(selectedPage, onSelectPage),
            ),
          ),
        ],
      ),
    );
  }
}

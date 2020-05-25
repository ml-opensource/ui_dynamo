import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/media_utils.dart';

class MainCell extends StatelessWidget {
  final String iconText;
  final String title;
  final String subtitle;
  final int count;
  final bool isFlipped;
  final GestureTapCallback onTap;

  const MainCell(
      {Key key,
      @required this.iconText,
      @required this.title,
      @required this.subtitle,
      @required this.count,
      this.isFlipped = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trailing =
        isFlipped ? MainCellAvatar(iconText: iconText) : buildText();
    final leading =
        isFlipped ? buildText() : MainCellAvatar(iconText: iconText);
    final titleText = Text(title);
    final subtitleText = Text(subtitle);
    if (context.isWatch) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    leading,
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: titleText,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4.0,
                ),
                subtitleText,
                trailing,
              ],
            ),
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: leading,
          title: titleText,
          subtitle: subtitleText,
          trailing: trailing,
          onTap: this.onTap,
        ),
      ),
    );
  }

  Text buildText() => Text("Count $count");
}

class MainCellAvatar extends StatelessWidget {
  const MainCellAvatar({
    Key key,
    @required this.iconText,
  }) : super(key: key);

  final String iconText;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(iconText),
      ),
    );
  }
}

class MainCellItem {
  final String iconText;
  final String title;
  final String subtitle;
  final int count;

  MainCellItem(this.iconText, this.title, this.subtitle, this.count);

  @override
  String toString() {
    return 'MainCellItem{iconText: $iconText, title: $title, subtitle: $subtitle, count: $count}';
  }
}

class MainCellList extends StatelessWidget {
  final List<MainCellItem> items;
  final Function(MainCellItem) onTap;

  const MainCellList({Key key, this.items, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, int) {
        final item = items[int];
        return MainCell(
          title: item.title,
          subtitle: item.subtitle,
          iconText: item.iconText,
          count: item.count,
          onTap: () => this.onTap?.call(item),
        );
      },
    );
  }
}

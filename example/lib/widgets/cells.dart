import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: isFlipped ? buildText() : buildCircleAvatar(),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: isFlipped ? buildCircleAvatar() : buildText(),
          onTap: this.onTap,
        ),
      ),
    );
  }

  Text buildText() => Text("Count $count");

  CircleAvatar buildCircleAvatar() {
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
}

class MainCellList extends StatelessWidget {
  final List<MainCellItem> items;
  final bool shrinkWrap;
  final Function(MainCellItem) onTap;

  const MainCellList({Key key, this.items, this.shrinkWrap = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      itemBuilder: (context, int) {
        final item = items[int];
        return MainCell(
          title: item.title,
          subtitle: item.subtitle,
          iconText: item.iconText,
          count: item.count,
          onTap: () => this.onTap(item),
        );
      },
    );
  }
}

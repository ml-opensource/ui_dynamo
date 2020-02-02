import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainCell extends StatelessWidget {
  final String iconText;
  final String title;
  final String subtitle;
  final int count;
  final bool isFlipped;

  const MainCell(
      {Key key,
      @required this.iconText,
      @required this.title,
      @required this.subtitle,
      @required this.count,
      this.isFlipped = false})
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

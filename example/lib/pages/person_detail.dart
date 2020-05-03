import 'package:example/widgets/cells.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonDetailArguments {
  final MainCellItem item;

  PersonDetailArguments(this.item);
}

class PersonDetail extends StatelessWidget {
  final MainCellItem item;

  const PersonDetail({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.subtitle),
            Text("Count ${item.count}"),
          ],
        ),
      ),
    );
  }
}

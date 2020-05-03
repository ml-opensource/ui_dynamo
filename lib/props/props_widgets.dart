import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PropTableItem {
  final String name;
  final String description;
  final String defaultValue;

  PropTableItem(
      {@required this.name,
      @required this.description,
      this.defaultValue = ''});
}

class PropTable extends StatelessWidget {
  final rowPadding = const EdgeInsets.only(top: 12.0, bottom: 12.0);

  final List<PropTableItem> items;
  final Widget title;

  static const defaultTextStyle = TextStyle(fontSize: 24);

  const PropTable(
      {Key key, @required this.items, this.title = const Text('Props')})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: DefaultTextStyle.merge(style: defaultTextStyle, child: this.title),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey,
                  )),
              children: [
                TableRow(children: [
                  PropTableHeader(
                    title: 'Name',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: PropTableHeader(
                      title: 'Description',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: PropTableHeader(
                      title: 'Default Value',
                    ),
                  ),
                ]),
                ...this.items.map((e) => buildTableRow(e)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow buildTableRow(PropTableItem e) => TableRow(
        children: [
          Padding(
            padding: rowPadding,
            child: Text(e.name),
          ),
          Padding(
            padding: rowPadding.copyWith(left: 12.0),
            child: Text(e.description),
          ),
          Padding(
            padding: rowPadding.copyWith(left: 12.0),
            child: Text(e.defaultValue),
          ),
        ],
      );
}

class PropTableHeader extends StatelessWidget {
  final String title;

  const PropTableHeader({
    Key key,
    @required this.title,
  }) : super(key: key);

  final padding = const EdgeInsets.only(top: 12.0, bottom: 12.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

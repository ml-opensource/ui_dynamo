import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/ui_dynamo.dart';
import 'package:ui_dynamo/ui/styles/text_styles.dart';

class PropTableItem {
  final String name;
  final String description;
  final String defaultValue;

  /// provide an example in the table
  /// the size of the example will be constrained and potentially cut off
  /// if too large.
  final Widget example;

  PropTableItem(
      {@required this.name,
      @required this.description,
      this.defaultValue = '',
      this.example});
}

class PropTable extends StatelessWidget {
  final rowPadding = const EdgeInsets.only(top: 12.0, bottom: 12.0);

  final List<PropTableItem> items;
  final Widget title;
  final double maxCellWidth;
  final double minCellWidth;
  final double dataRowHeight;

  const PropTable({
    Key key,
    @required this.items,
    this.title = const Text('Props'),
    this.maxCellWidth = 200,
    this.minCellWidth = 0,
    this.dataRowHeight = 100,
  }) : super(key: key);

  BoxConstraints _cellConstraints() =>
      BoxConstraints(maxWidth: maxCellWidth, minWidth: minCellWidth);

  DataRow _buildTableRow(PropTableItem e, bool hasExample) => DataRow(
        cells: [
          DataCell(
              Container(constraints: _cellConstraints(), child: Text(e.name))),
          DataCell(Container(
              constraints: _cellConstraints(), child: Text(e.description))),
          DataCell(Container(
              constraints: _cellConstraints(), child: Text(e.defaultValue))),
          if (e.example != null)
            DataCell(
                Container(constraints: _cellConstraints(), child: e.example))
          else if (hasExample)
            DataCell(Text(''))
        ],
      );

  @override
  Widget build(BuildContext context) {
    final hasExample = items.firstWhere((element) => element.example != null,
            orElse: () => null) !=
        null;
    return Organization.presentation(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DefaultTextStyle.merge(
                    style: headerStyle, child: this.title),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Default Value')),
                    if (hasExample) DataColumn(label: Text('Example')),
                  ],
                  dataRowHeight: dataRowHeight,
                  rows: this
                      .items
                      .map((e) => _buildTableRow(e, hasExample))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

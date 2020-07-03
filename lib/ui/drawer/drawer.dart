import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/ui_dynamo.dart';
import 'package:ui_dynamo/ui/model/page.dart';

import '../../models.dart';

class DynamoDrawer extends StatelessWidget {
  final DynamoData data;
  final Function(DynamoItem, DynamoPage) onSelectPage;
  final DynamoPage selectedPage;

  const DynamoDrawer({
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
          data.customDrawerHeader ??
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: [
                        Icon(Icons.book),
                        StyledText.header(data.title),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
          Expanded(
            child: RoutesList(
                data: data,
                selectedPage: selectedPage,
                onSelectPage: onSelectPage),
          ),
        ],
      ),
    );
  }
}

class RoutesList extends StatelessWidget {
  const RoutesList({
    Key key,
    @required this.data,
    @required this.selectedPage,
    @required this.onSelectPage,
    this.shrinkWrap = false,
  }) : super(key: key);

  final DynamoData data;
  final DynamoPage selectedPage;
  final Function(DynamoItem p1, DynamoPage p2) onSelectPage;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: shrinkWrap ? NeverScrollableScrollPhysics() : null,
      shrinkWrap: shrinkWrap,
      separatorBuilder: (context, index) => Divider(
        height: 1,
      ),
      itemCount: data.items.length,
      itemBuilder: (context, index) =>
          data.items[index].buildWidget(selectedPage, onSelectPage),
    );
  }
}

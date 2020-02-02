import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_ui.dart';
import 'package:flutter_storybook/props/props_ui.dart';

class ToolbarPane extends StatelessWidget {
  const ToolbarPane({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            thickness: 2,
          ),
          Row(
            children: <Widget>[
              TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    text: 'Actions',
                  ),
                  Tab(
                    text: 'Props',
                  )
                ],
                indicatorColor: Colors.indigo,
                labelColor: Colors.black,
              ),
            ],
          ),
          Container(
            height: 300,
            color: Colors.white70,
            child: TabBarView(
              children: <Widget>[
                ActionsDisplay(),
                PropsDisplay(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

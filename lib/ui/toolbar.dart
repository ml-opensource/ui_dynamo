import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_ui.dart';
import 'package:flutter_storybook/props/props_ui.dart';

class ToolbarPane extends StatefulWidget {
  const ToolbarPane({
    Key key,
  }) : super(key: key);

  @override
  _ToolbarPaneState createState() => _ToolbarPaneState();
}

class _ToolbarPaneState extends State<ToolbarPane> {
  bool toolbarOpen = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(
            thickness: 2,
            height: 2,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TabBar(
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
              ),
              IconButton(
                icon: Icon(toolbarOpen ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    toolbarOpen = !toolbarOpen;
                  });
                },
              ),
            ],
          ),
          Container(
            height: toolbarOpen ? MediaQuery.of(context).size.height / 4 : 0,
            color: Theme.of(context).scaffoldBackgroundColor,
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

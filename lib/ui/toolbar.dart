import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_ui.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/props/props_ui.dart';
import 'package:flutter_storybook/ui/widgets/measuresize.dart';

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
    final tabTextColor =
        TextStyle(color: Theme.of(context).textTheme.button.color);
    final provider = mediaQuery(context);
    return MeasureSize(
      onChange: (size) => provider.bottomBarHeightChanged(size.height),
      child: DefaultTabController(
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
                    onTap: (index) {
                      setState(() {
                        toolbarOpen = true;
                      });
                    },
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Text(
                          'Actions',
                          style: tabTextColor,
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Props',
                          style: tabTextColor,
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  icon:
                      Icon(toolbarOpen ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      toolbarOpen = !toolbarOpen;
                    });
                  },
                ),
              ],
            ),
            Draggable(
              axis: Axis.vertical,
              feedback: Text('DRAGGING'),
              dragAnchor: DragAnchor.pointer,
              child: Container(
                height:
                    toolbarOpen ? MediaQuery.of(context).size.height / 4 : 0,
                child: TabBarView(
                  children: <Widget>[
                    ActionsDisplay(),
                    PropsDisplay(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmptyToolbarView extends StatelessWidget {
  final Widget text;

  const EmptyToolbarView({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: text,
      ),
    );
  }
}

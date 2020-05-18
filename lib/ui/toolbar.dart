import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:flutter_storybook/ui/widgets/measuresize.dart';

class ToolbarPane extends StatefulWidget {
  final List<StoryBookPlugin> plugins;

  const ToolbarPane({
    Key key,
    this.plugins = const [],
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
    final plugins = widget.plugins;
    final media = MediaQuery.of(context);
    return MeasureSize(
      onChange: (size) => provider.bottomBarHeightChanged(size.height),
      child: Builder(
        builder: (context) => DefaultTabController(
          length: plugins.length,
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
                        ...plugins.map((e) => Tab(
                              child: Text(
                                e.bottomTabText,
                                style: tabTextColor,
                              ),
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        toolbarOpen ? Icons.expand_less : Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        toolbarOpen = !toolbarOpen;
                        MeasureSizeProvider.of(context).notifySizeChange();
                      });
                    },
                  ),
                ],
              ),
              Container(
                height: toolbarOpen
                    ? max(
                        (media.size.height / 3) - provider.toolbarHeight,
                        min((media.size.height / 2) - provider.toolbarHeight,
                            300))
                    : 0,
                child: TabBarView(
                  children: <Widget>[
                    ...plugins.map((e) => e.bottomTabPane(context)),
                  ],
                ),
              )
            ],
          ),
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

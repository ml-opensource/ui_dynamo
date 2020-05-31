import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:flutter_storybook/ui/widgets/measuresize.dart';

class ToolbarPane extends StatefulWidget {
  final List<StoryBookPlugin> plugins;
  final bool onBottom;

  const ToolbarPane({
    Key key,
    this.plugins = const [],
    this.onBottom,
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
    final provider = context.mediaQueryProvider;
    final plugins = widget.plugins;
    final media = MediaQuery.of(context);
    return Visibility(
      visible: plugins.length > 0,
      child: MeasureSize(
        onChange: (size) {
          if (widget.onBottom) {
            provider.pluginsUISizeChanged(Size(0, size.height));
          } else {
            provider.pluginsUISizeChanged(Size(size.width, 0));
          }
        },
        child: Builder(
          builder: (context) {
            var viewPortHeightCalculate =
                provider.viewPortHeightCalculate(media.size.height);
            return Container(
              decoration: widget.onBottom
                  ? null
                  : BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
              constraints: widget.onBottom
                  ? null
                  : BoxConstraints(maxWidth: toolbarWidth(media)),
              child: DefaultTabController(
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
                        if (widget.onBottom || toolbarOpen)
                          buildTabBar(plugins, tabTextColor),
                        IconButton(
                          tooltip: toolbarOpen
                              ? "Close Plugins Toolbar"
                              : "Open Plugins Toolbar",
                          icon: buildIconForToolbar(),
                          onPressed: () {
                            setState(() {
                              toolbarOpen = !toolbarOpen;
                              MeasureSizeProvider.of(context)
                                  .notifySizeChange();
                            });
                          },
                        ),
                      ],
                    ),
                    Flexible(
                      child: Visibility(
                        visible: (widget.onBottom || toolbarOpen),
                        child: Container(
                          height: widget.onBottom
                              ? toolbarHeight(media, provider)
                              : viewPortHeightCalculate,
                          child: TabBarView(
                            children: <Widget>[
                              ...plugins.map((e) => e.tabPane(context)),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Expanded buildTabBar(
      List<StoryBookPlugin<ChangeNotifier>> plugins, TextStyle tabTextColor) {
    return Expanded(
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
                  e.tabText,
                  style: tabTextColor,
                ),
              )),
        ],
      ),
    );
  }

  double toolbarWidth(MediaQueryData media) {
    return toolbarOpen
        ? max((media.size.width / 3), min((media.size.width / 2), 300))
        : 50;
  }

  Icon buildIconForToolbar() {
    if (widget.onBottom) {
      return Icon(toolbarOpen ? Icons.expand_less : Icons.expand_more);
    } else {
      return Icon(toolbarOpen ? Icons.arrow_right : Icons.arrow_left);
    }
  }

  double toolbarHeight(
      MediaQueryData media, OverrideMediaQueryProvider provider) {
    return toolbarOpen
        ? max((media.size.height / 3) - provider.toolbarHeight,
            min((media.size.height / 2) - provider.toolbarHeight, 300))
        : 0;
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

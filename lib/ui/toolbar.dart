import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/mediaquery/override_media_query_plugin.dart';
import 'package:ui_dynamo/plugins/plugin.dart';
import 'package:ui_dynamo/ui/widgets/measuresize.dart';

class ToolbarPane extends StatefulWidget {
  final List<DynamoPlugin> plugins;
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
        onChange: _sizeChanged,
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
              child: Column(
                mainAxisSize:
                    widget.onBottom ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  Divider(
                    thickness: 2,
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: widget.onBottom || toolbarOpen,
                        child: Flexible(
                          child: DefaultTabController(
                            length: plugins.length,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if (widget.onBottom || toolbarOpen)
                                      buildTabBar(plugins, tabTextColor),
                                    if (widget.onBottom)
                                      _ExpandableToolbarIcon(
                                        toolbarOpen: toolbarOpen,
                                        onBottom: widget.onBottom,
                                        onOpenChange: _onOpenChange,
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
                                          ...plugins
                                              .map((e) => e.tabPane(context)),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (!widget.onBottom)
                        _ExpandableToolbarIcon(
                          toolbarOpen: toolbarOpen,
                          onBottom: widget.onBottom,
                          onOpenChange: _onOpenChange,
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _onOpenChange(bool value) {
    setState(() {
      toolbarOpen = value;
    });
  }

  void _sizeChanged(Size size) {
    final provider = context.mediaQueryProvider;
    if (widget.onBottom) {
      provider.pluginsUISizeChanged(Size(0, size.height));
    } else {
      provider.pluginsUISizeChanged(Size(size.width, 0));
    }
  }

  Expanded buildTabBar(
      List<DynamoPlugin<ChangeNotifier>> plugins, TextStyle tabTextColor) {
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
    return widget.onBottom
        ? Icon(toolbarOpen ? Icons.expand_less : Icons.expand_more)
        : Icon(toolbarOpen ? Icons.arrow_right : Icons.arrow_left);
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

class _ExpandableToolbarIcon extends StatelessWidget {
  final bool toolbarOpen;
  final bool onBottom;
  final Function(bool) onOpenChange;

  const _ExpandableToolbarIcon(
      {Key key,
      @required this.toolbarOpen,
      @required this.onBottom,
      @required this.onOpenChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: onBottom ? 0 : 1,
      child: Tooltip(
        message: toolbarOpen ? "Close Plugins Toolbar" : "Open Plugins Toolbar",
        child: InkWell(
          onTap: () {
            onOpenChange(!toolbarOpen);
            MeasureSizeProvider.of(context).notifySizeChange();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(toolbarOpen ? Icons.expand_less : Icons.expand_more),
                SizedBox(
                  width: 8,
                ),
                Text(toolbarOpen ? "Close" : "Open"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef StorybookWidgetBuilder = Widget Function(
    BuildContext context, MediaQueryData queryData, MaterialApp app);

class StoryBookWidget {
  final StorybookWidgetBuilder builder;

  StoryBookWidget(this.builder);

  factory StoryBookWidget.widgetBuilder(WidgetBuilder builder) =>
      StoryBookWidget((context, data, app) =>
          MediaQuery(data: data, child: builder(context)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookWidget &&
          runtimeType == other.runtimeType &&
          builder == other.builder;

  @override
  int get hashCode => builder.hashCode;
}

class StoryBookWidgetList extends StoryBookWidget {
  final List<Widget> Function(BuildContext context) widgets;

  StoryBookWidgetList(this.widgets)
      : super(
          (context, data, app) => MediaQuery(
            data: data,
            child: ListView(
              children: <Widget>[
                ...widgets(context),
              ],
            ),
          ),
        );
}

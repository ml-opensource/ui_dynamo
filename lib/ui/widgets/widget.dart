import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/mediaquery.dart';

class StoryBookWidget {
  final MediaWidgetBuilder builder;

  StoryBookWidget(this.builder);

  factory StoryBookWidget.widgetBuilder(WidgetBuilder builder) =>
      StoryBookWidget(
          (context, data) => MediaQuery(data: data, child: builder(context)));

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
          (context, data) => MediaQuery(
            data: data,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: ListView(
                children: <Widget>[
                  ...widgets(context),
                ],
              ),
            ),
          ),
        );
}

import 'package:flutter/widgets.dart';

class StoryBookWidget {
  final WidgetBuilder childBuilder;

  StoryBookWidget(this.childBuilder);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookWidget &&
          runtimeType == other.runtimeType &&
          childBuilder == other.childBuilder;

  @override
  int get hashCode => childBuilder.hashCode;
}

class StoryBookWidgetList extends StoryBookWidget {
  final List<Widget> Function(BuildContext context) widgets;

  StoryBookWidgetList(this.widgets)
      : super((context) => Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: ListView(
              children: <Widget>[
                ...widgets(context),
              ],
            )));
}

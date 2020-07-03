import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef DynamoWidgetBuilder = Widget Function(
    BuildContext context, MediaQueryData queryData, MaterialApp app);

class DynamoWidget {
  final DynamoWidgetBuilder builder;

  DynamoWidget(this.builder);

  factory DynamoWidget.widgetBuilder(WidgetBuilder builder) =>
      DynamoWidget((context, data, app) =>
          MediaQuery(data: data, child: builder(context)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamoWidget &&
          runtimeType == other.runtimeType &&
          builder == other.builder;

  @override
  int get hashCode => builder.hashCode;
}

class DynamoWidgetList extends DynamoWidget {
  final List<Widget> Function(BuildContext context) widgets;

  DynamoWidgetList(this.widgets)
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

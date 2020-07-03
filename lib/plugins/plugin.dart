import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// A plugin that inserts itself into the book pane.
/// Specify an optional [Provider] to inject into buildable pages for
/// the main Dynamo.
class DynamoPlugin<T extends ChangeNotifier> {
  final ChangeNotifierProvider<T> provider;

  final WidgetBuilder tabPane;

  final String tabText;

  DynamoPlugin({this.provider, this.tabPane, this.tabText});
}

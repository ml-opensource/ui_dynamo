import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// A plugin that inserts itself into the book pane.
/// Specify an optional [Provider] to inject into buildable pages for
/// the main StoryBook.
class StoryBookPlugin<T extends ChangeNotifier> {
  final ChangeNotifierProvider<T> provider;

  final WidgetBuilder tabPane;

  final String tabText;

  StoryBookPlugin({this.provider, this.tabPane, this.tabText});
}

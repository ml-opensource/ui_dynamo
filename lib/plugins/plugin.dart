import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/// A plugin that inserts itself into the book pane.
/// Specify an optional [Provider] to inject into buildable pages for
/// the main StoryBook.
class StoryBookPlugin<T extends ChangeNotifier> {
  final ValueBuilder<T> provider;

  final WidgetBuilder bottomTabPane;

  final String bottomTabText;

  StoryBookPlugin(
      {this.provider,
      @required this.bottomTabPane,
      @required this.bottomTabText});
}

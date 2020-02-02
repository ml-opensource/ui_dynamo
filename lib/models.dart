import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class StoryBookData {
  final Widget title;
  final List<StoryBookFolder> folders;

  StoryBookData({this.title, @required this.folders});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          folders == other.folders;

  @override
  int get hashCode => title.hashCode ^ folders.hashCode;
}

class StoryBookFolder {
  final Key key;
  final Widget title;
  final Icon icon;

  final List<StoryBookPage> pages;

  StoryBookFolder(
      {@required this.key,
      @required this.title,
      this.pages = const [],
      this.icon});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookFolder &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          icon == other.icon &&
          pages == other.pages;

  @override
  int get hashCode =>
      key.hashCode ^ title.hashCode ^ icon.hashCode ^ pages.hashCode;
}

class StoryBookPage {
  final Key key;
  final Widget title;
  final Icon icon;

  /// Returns the widgets to render in a page. These are loaded when page clicked.
  final List<StoryBookWidget> widgets;

  StoryBookPage(
      {@required this.key,
      @required this.title,
      this.icon,
      @required this.widgets});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookPage &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          icon == other.icon &&
          widgets == other.widgets;

  @override
  int get hashCode =>
      key.hashCode ^ title.hashCode ^ icon.hashCode ^ widgets.hashCode;
}

class StoryBookWidget {
  final WidgetBuilder childBuilder;

  StoryBookWidget({@required this.childBuilder});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookWidget &&
          runtimeType == other.runtimeType &&
          childBuilder == other.childBuilder;

  @override
  int get hashCode => childBuilder.hashCode;
}

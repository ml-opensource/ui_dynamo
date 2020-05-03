import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

abstract class StoryBookItem {
  final Key key;
  final Widget title;
  final Icon icon;

  StoryBookItem(this.key, this.title, this.icon);

  /// Find the selected page from key.
  StoryBookPage pageFromKey(Key key);

  Widget buildWidget(StoryBookPage selectedPage,
      Function(StoryBookItem, StoryBookPage) onSelectPage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookItem &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          icon == other.icon;

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ icon.hashCode;
}

class StoryBookData {
  final Widget title;
  final List<StoryBookItem> items;

  StoryBookData({this.title, @required this.items});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          items == other.items;

  @override
  int get hashCode => title.hashCode ^ items.hashCode;

  StoryBookData merge({List<StoryBookItem> items = const [], Widget title}) =>
      StoryBookData(title: title ?? this.title, items: [
        ...items,
        ...this.items,
      ]);
}

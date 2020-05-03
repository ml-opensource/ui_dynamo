import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_storybook/ui/widgets/folder.dart';

class StoryBookData {
  final Widget title;
  final List<StoryBookFolder> items;

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
}

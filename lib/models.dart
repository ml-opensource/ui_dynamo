import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';

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
  /// Customize the title of the storybook.
  final Widget title;

  /// The list of menu items appearing as pages, folders, or storybooks.
  final List<StoryBookItem> items;

  /// Customize the header on the drawer. Default is DrawerHeader widget.
  final Widget customDrawerHeader;

  /// the initial preview size for all nested windows.
  final DeviceInfo defaultDevice;

    StoryBookData(
      {this.title,
      @required this.items,
      this.customDrawerHeader,
      this.defaultDevice});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryBookData &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          items == other.items &&
          customDrawerHeader == other.customDrawerHeader &&
          defaultDevice == other.defaultDevice;

  @override
  int get hashCode =>
      title.hashCode ^
      items.hashCode ^
      customDrawerHeader.hashCode ^
      defaultDevice.hashCode;

  StoryBookData merge(
          {List<StoryBookItem> items = const [],
          Widget title,

          /// if true, we merge the items at start.
          bool mergeFirst = true}) =>
      copyWith(title: title ?? this.title, items: [
        if (mergeFirst) ...items,
        ...this.items,
        if (!mergeFirst) ...items,
      ]);

  StoryBookData copyWith({
    Widget title,
    List<StoryBookItem> items,
    Widget customDrawerHeader,
    DeviceInfo defaultDevice,
  }) =>
      StoryBookData(
          items: items ?? this.items,
          title: title ?? this.title,
          customDrawerHeader: customDrawerHeader ?? this.customDrawerHeader,
          defaultDevice: defaultDevice ?? this.defaultDevice);
}

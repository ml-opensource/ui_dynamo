import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ui_dynamo/ui_dynamo.dart';
import 'package:ui_dynamo/mediaquery/device_sizes.dart';

abstract class DynamoItem {
  final Key key;
  final Widget title;
  final Icon icon;

  DynamoItem(this.key, this.title, this.icon);

  /// Find the selected page from key.
  DynamoPage pageFromKey(Key key);

  Widget buildWidget(DynamoPage selectedPage,
      Function(DynamoItem, DynamoPage) onSelectPage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamoItem &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          icon == other.icon;

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ icon.hashCode;
}

class DynamoData {
  /// Customize the title of UIDynamo.
  final Widget title;

  /// The list of menu items appearing as pages, folders, or storyboards.
  final List<DynamoItem> items;

  /// Customize the header on the drawer. Default is DrawerHeader widget.
  final Widget customDrawerHeader;

  /// the initial preview size for all nested windows.
  final DeviceInfo defaultDevice;

    DynamoData(
      {this.title,
      this.items = const [],
      this.customDrawerHeader,
      this.defaultDevice});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamoData &&
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

  DynamoData merge(
          {List<DynamoItem> items = const [],
          Widget title,

          /// if true, we merge the items at start.
          bool mergeFirst = true}) =>
      copyWith(title: title ?? this.title, items: [
        if (mergeFirst) ...items,
        ...this.items,
        if (!mergeFirst) ...items,
      ]);

  DynamoData copyWith({
    Widget title,
    List<DynamoItem> items,
    Widget customDrawerHeader,
    DeviceInfo defaultDevice,
  }) =>
      DynamoData(
          items: items ?? this.items,
          title: title ?? this.title,
          customDrawerHeader: customDrawerHeader ?? this.customDrawerHeader,
          defaultDevice: defaultDevice ?? this.defaultDevice);
}

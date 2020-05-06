import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum DeviceCategory { Mobile, Tablet, Desktop, Expand }

class DeviceInfo {
  final String name;
  final Size logicalSize;
  final Size pixelSize;
  final DeviceCategory category;

  const DeviceInfo(this.name, this.logicalSize, this.pixelSize, this.category);

  DeviceInfo copyWith({
    String name,
    Size logicalSize,
    Size pixelSize,
    DeviceCategory category,
  }) =>
      DeviceInfo(name ?? this.name, logicalSize ?? this.logicalSize,
          pixelSize ?? this.pixelSize, category ?? this.category);

  IconData get iconForCategory {
    switch (category) {
      case DeviceCategory.Desktop:
        return Icons.desktop_mac;
      case DeviceCategory.Tablet:
        return Icons.tablet_mac;
      case DeviceCategory.Expand:
        return Icons.settings_ethernet;
      case DeviceCategory.Mobile:
      default:
        return Icons.smartphone;
    }
  }
}

class DeviceSizes {
  static const window =
      DeviceInfo('Window', Size.infinite, Size.infinite, DeviceCategory.Expand);
  static const iphone5 = DeviceInfo(
      'iPhone 5', Size(320, 568), Size(640, 1136), DeviceCategory.Mobile);
  static const iphone6 = DeviceInfo(
      'iPhone 6', Size(375, 667), Size(750, 1334), DeviceCategory.Mobile);
  static const iphone678PlusZoom = DeviceInfo('iPhone 6/7/8 Plus Zoom',
      Size(414, 736), Size(1080, 1920), DeviceCategory.Mobile);
  static const iphone678PlusFull = DeviceInfo('iPhone 6/7/8 Plus Full',
      Size(414, 736), Size(1242, 2208), DeviceCategory.Mobile);
  static const iphoneX = DeviceInfo(
      'iPhone X', Size(375, 812), Size(1125, 2436), DeviceCategory.Mobile);
  static const iphoneXR11 = DeviceInfo(
      'iPhone XR/11', Size(414, 896), Size(828, 1792), DeviceCategory.Mobile);
  static const iphoneXS11Max = DeviceInfo('iPhone XS/11 Max', Size(414, 896),
      Size(1242, 2688), DeviceCategory.Mobile);
  static const ipad12 = DeviceInfo('iPad 1st/2nd Gen', Size(768, 1024),
      Size(768, 1024), DeviceCategory.Tablet);
  static const ipadPro10_5 = DeviceInfo('iPad Pro 10.5-in', Size(834, 1112),
      Size(1668, 2224), DeviceCategory.Tablet);
  static const ipadPro11 = DeviceInfo('iPad Pro 11-in', Size(834, 1194),
      Size(1668, 2388), DeviceCategory.Tablet);
  static const ipadPro12_9 = DeviceInfo('iPad Pro 12.9-in', Size(1024, 1366),
      Size(2048, 2732), DeviceCategory.Tablet);
  static const galaxyS7 = DeviceInfo(
      'Galaxy S7', Size(360, 640), Size(1440, 2560), DeviceCategory.Mobile);
  static const galaxyS8 = DeviceInfo(
      'Galaxy S8', Size(360, 740), Size(1440, 2960), DeviceCategory.Mobile);
  static const nexus5X = DeviceInfo(
      'Nexus 5X', Size(411, 731), Size(1080, 1920), DeviceCategory.Mobile);
  static const nexus6P = DeviceInfo(
      'Nexus 6P', Size(411, 731), Size(1440, 2560), DeviceCategory.Mobile);
  static const pixel = DeviceInfo(
      'Pixel', Size(411, 731), Size(1080, 1920), DeviceCategory.Mobile);
  static const pixelXL = DeviceInfo(
      'Pixel XL', Size(411, 731), Size(1440, 2560), DeviceCategory.Mobile);
}

const List<DeviceInfo> deviceSizes = [
  DeviceSizes.window,
  DeviceSizes.iphone5,
  DeviceSizes.iphone6,
  DeviceSizes.iphone678PlusZoom,
  DeviceSizes.iphone678PlusFull,
  DeviceSizes.iphoneX,
  DeviceSizes.iphoneXR11,
  DeviceSizes.iphoneXS11Max,
  DeviceSizes.ipad12,
  DeviceSizes.ipadPro10_5,
  DeviceSizes.ipadPro11,
  DeviceSizes.ipadPro12_9,
  DeviceSizes.galaxyS7,
  DeviceSizes.galaxyS8,
  DeviceSizes.nexus5X,
  DeviceSizes.nexus6P,
  DeviceSizes.pixel,
  DeviceSizes.pixelXL,
];

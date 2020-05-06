import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum DeviceCategory { Mobile, Tablet, Desktop, Expand }

class DeviceInfo {
  final String name;
  final Size logicalSize;
  final Size pixelSize;
  final DeviceCategory category;

  const DeviceInfo(this.name, this.logicalSize, this.pixelSize, this.category);

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

const List<DeviceInfo> deviceSizes = [
  DeviceInfo('Window', Size.infinite, Size.infinite, DeviceCategory.Expand),
  DeviceInfo(
      'iPhone 5', Size(320, 568), Size(640, 1136), DeviceCategory.Mobile),
  DeviceInfo(
      'iPhone 6', Size(375, 667), Size(750, 1334), DeviceCategory.Mobile),
  DeviceInfo('iPhone 6/7/8 Plus Zoom', Size(414, 736), Size(1080, 1920),
      DeviceCategory.Mobile),
  DeviceInfo('iPhone 6/7/8 Plus Full', Size(414, 736), Size(1242, 2208),
      DeviceCategory.Mobile),
  DeviceInfo(
      'iPhone X', Size(375, 812), Size(1125, 2436), DeviceCategory.Mobile),
  DeviceInfo(
      'iPhone XR/11', Size(414, 896), Size(828, 1792), DeviceCategory.Mobile),
  DeviceInfo('iPhone XS/11 Max', Size(414, 896), Size(1242, 2688),
      DeviceCategory.Mobile),
  DeviceInfo('iPad 1st/2nd Gen', Size(768, 1024), Size(768, 1024),
      DeviceCategory.Tablet),
  DeviceInfo('iPad Pro 10.5-in', Size(834, 1112), Size(1668, 2224),
      DeviceCategory.Tablet),
  DeviceInfo('iPad Pro 11-in', Size(834, 1194), Size(1668, 2388),
      DeviceCategory.Tablet),
  DeviceInfo('iPad Pro 12.9-in', Size(1024, 1366), Size(2048, 2732),
      DeviceCategory.Tablet),
  DeviceInfo(
      'Galaxy S7', Size(360, 640), Size(1440, 2560), DeviceCategory.Mobile),
  DeviceInfo(
      'Galaxy S8', Size(360, 740), Size(1440, 2960), DeviceCategory.Mobile),
  DeviceInfo(
      'Nexus 5X', Size(411, 731), Size(1080, 1920), DeviceCategory.Mobile),
  DeviceInfo(
      'Nexus 6P', Size(411, 731), Size(1440, 2560), DeviceCategory.Mobile),
  DeviceInfo('Pixel', Size(411, 731), Size(1080, 1920), DeviceCategory.Mobile),
  DeviceInfo(
      'Pixel XL', Size(411, 731), Size(1440, 2560), DeviceCategory.Mobile),
];

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum DeviceCategory { Mobile, Tablet, Desktop, Expand }

class DeviceInfo {
  final String name;
  final Size size;
  final DeviceCategory category;

  const DeviceInfo(this.name, this.size, this.category);

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
  DeviceInfo('Window', Size.infinite, DeviceCategory.Expand),
  DeviceInfo('iPhone 5', Size(320, 568), DeviceCategory.Mobile),
  DeviceInfo('iPhone 6', Size(375, 667), DeviceCategory.Mobile),
  DeviceInfo('iPhone 6/7/8 Plus', Size(414, 736), DeviceCategory.Mobile),
  DeviceInfo('iPhone X', Size(375, 812), DeviceCategory.Mobile),
  DeviceInfo('iPhone XR/XS Max', Size(414, 896), DeviceCategory.Mobile),
  DeviceInfo('iPad', Size(768, 1024), DeviceCategory.Tablet),
  DeviceInfo('iPad Pro 10.5-in', Size(834, 1112), DeviceCategory.Tablet),
  DeviceInfo('iPad Pro 12.9-in', Size(1024, 1366), DeviceCategory.Tablet),
  DeviceInfo('Galaxy S5', Size(360, 640), DeviceCategory.Mobile),
  DeviceInfo('Galaxy S9', Size(720, 1460), DeviceCategory.Mobile),
  DeviceInfo('Nexus 5X', Size(412, 660), DeviceCategory.Mobile),
  DeviceInfo('Nexus 6P', Size(412, 732), DeviceCategory.Mobile),
  DeviceInfo('Pixel', Size(540, 960), DeviceCategory.Mobile),
  DeviceInfo('Pixel XL', Size(720, 1280), DeviceCategory.Mobile),
];

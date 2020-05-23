import 'package:flutter/material.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/mediaquery/device_size_plugin.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/ui/page_wrapper.dart';

class MediaChooserButton extends StatelessWidget {
  final Function(DeviceInfo) deviceSelected;
  final DeviceInfo selectedDevice;

  const MediaChooserButton({
    Key key,
    @required this.deviceSelected,
    @required this.selectedDevice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceName =
        deviceDisplay(context, selectedDevice, shortName: isMobile(context));
    return PopupMenuButton(
      tooltip: 'Choose Preview Window Size',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(deviceName),
            SizedBox(
              width: 8,
            ),
            Icon(
              selectedDevice.iconForCategory,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
      ),
      onSelected: deviceSelected,
      itemBuilder: (BuildContext context) => context.deviceSizes.devices
          .map(
            (key) => buildDeviceOption(context, key, selectedDevice),
          )
          .toList(),
    );
  }

  PopupMenuItem<DeviceInfo> buildDeviceOption(
      BuildContext context, DeviceInfo deviceInfo, DeviceInfo selectedDevice) {
    return CheckedPopupMenuItem(
      checked: selectedDevice == deviceInfo,
      value: deviceInfo,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(deviceInfo.iconForCategory),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Text(
              deviceDisplay(context, deviceInfo),
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}

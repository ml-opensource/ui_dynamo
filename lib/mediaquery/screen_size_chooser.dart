import 'package:flutter/material.dart';
import 'package:flutter_storybook/mediaquery/mediaquery.dart';

class MediaChooserButton extends StatelessWidget {
  final Function(String) deviceSelected;
  final String selectedDeviceName;

  const MediaChooserButton({
    Key key,
    @required this.deviceSelected,
    @required this.selectedDeviceName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.view_list,
        color: Theme.of(context).iconTheme.color,
      ),
      onSelected: deviceSelected,
      itemBuilder: (BuildContext context) => [
        CheckedPopupMenuItem(
          checked: selectedDeviceName == null,
          value: '',
          child: Row(
            children: <Widget>[
              Text(
                'Device Window Size',
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
        ...deviceSizes.keys.map(
          (key) => buildDeviceOption(key, deviceSizes[key], selectedDeviceName),
        ),
      ],
    );
  }

  PopupMenuItem<String> buildDeviceOption(
      String key, Size deviceSize, String selectedDeviceName) {
    return CheckedPopupMenuItem(
      checked: selectedDeviceName == key,
      value: key,
      child: Text(
        deviceDisplay(key, deviceSize),
        style: TextStyle(fontSize: 12.0),
      ),
    );
  }
}

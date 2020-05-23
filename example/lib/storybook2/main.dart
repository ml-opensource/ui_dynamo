import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/ui/book.dart';

void main() => runApp(AppStoryBook());

class AppStoryBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoryBook.withApp(buildApp(),
        useDeviceSizeDefaults: false,
        extraDevices: [
          DeviceInfo('Custom Device', Size(1000, 1000), Size(1000, 1000),
              DeviceCategory.Desktop),
          DeviceSizes.appleWatchSeries5_44,
        ],
        data: StoryBookData(
          items: [],
        ));
  }
}

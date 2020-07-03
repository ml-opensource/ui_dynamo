import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:ui_dynamo/ui_dynamo.dart';
import 'package:ui_dynamo/mediaquery/device_sizes.dart';
import 'package:ui_dynamo/ui/book.dart';

void main() => runApp(AppDynamo());

class AppDynamo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dynamo.withApp(
      buildApp(),
      useDeviceSizeDefaults: false,
      extraDevices: [
        DeviceInfo('Custom Device', Size(1000, 1000), Size(1000, 1000),
            DeviceCategory.Desktop),
        DeviceSizes.appleWatchSeries5_44,
      ],
      useDefaultPlugins: false,
      data: DynamoData(
        items: [],
      ),
    );
  }
}

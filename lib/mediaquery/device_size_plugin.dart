import 'package:flutter/material.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:provider/provider.dart';

/// Provides the [DeviceInfo] to Storybook.
/// Use this plugin to add more of your own.
class DeviceSizesPlugin extends ChangeNotifier {
  final List<DeviceInfo> _devices;

  /// Retrieves [DeviceSizesPlugin] from the [BuildContext]
  factory DeviceSizesPlugin.of(BuildContext context) =>
      Provider.of<DeviceSizesPlugin>(context);

  DeviceSizesPlugin(Iterable<DeviceInfo> extraDevices, bool useDefaults)
      : this._devices = useDefaults
            ? [...deviceSizes]
            : [DeviceSizes.window, ...extraDevices] {
    if (useDefaults) {
      _devices.addAll(extraDevices);
    }
  }

  List<DeviceInfo> get devices => _devices;
}

/// Handy extension on [BuildContext]
extension DeviceSizesPluginExtension on BuildContext {
  DeviceSizesPlugin get deviceSizes => DeviceSizesPlugin.of(this);
}

StoryBookPlugin deviceSizesPlugin(
        {Iterable<DeviceInfo> extraDevices = const [],
        bool useDefaults = true}) =>
    StoryBookPlugin<DeviceSizesPlugin>(
      provider: ChangeNotifierProvider(
          create: (context) => DeviceSizesPlugin(extraDevices, useDefaults)),
    );

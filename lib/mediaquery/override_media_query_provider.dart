import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';
import 'package:provider/provider.dart';

class OverrideMediaQueryProvider extends ChangeNotifier {
  MediaQueryData _currentMediaQuery;
  MediaQueryData _boundedMediaQuery;
  DeviceInfo _currentDeviceSelected;

  OverrideMediaQueryProvider(this._currentDeviceSelected);

  void selectMediaQuery(MediaQueryData query) {
    this._currentMediaQuery = query;
    this._boundedMediaQuery = _currentMediaQuery;
    notifyListeners();
  }

  void selectCurrentDevice(DeviceInfo deviceInfo) {
    this._currentDeviceSelected = deviceInfo;
    notifyListeners();
  }

  MediaQueryData get currentMediaQuery => _currentMediaQuery;

  MediaQueryData get boundedMediaQuery => _boundedMediaQuery;

  DeviceInfo get currentDevice => _currentDeviceSelected;
}

OverrideMediaQueryProvider mediaQuery(BuildContext context) {
  final provider = Provider.of<OverrideMediaQueryProvider>(context);
  if (provider._currentMediaQuery == null) {
    provider._currentMediaQuery = MediaQuery.of(context);
  }
  provider._boundedMediaQuery = provider._currentMediaQuery.copyWith(
    size: provider.currentDevice.logicalSize.boundedSize(context),
  );
  return provider;
}

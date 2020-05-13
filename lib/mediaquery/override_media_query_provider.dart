import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';
import 'package:provider/provider.dart';

class OverrideMediaQueryProvider extends ChangeNotifier {
  MediaQueryData _currentMediaQuery;
  MediaQueryData _boundedMediaQuery;
  DeviceInfo _currentDeviceSelected;
  double _currentScreenScale = 1.0;
  double _toolbarHeight = 0;

  /// this will be offset at scale 1.0
  Offset _currentOffset = Offset.zero;

  /// this will be used when changing scale, to represent offset as function
  /// of current.
  Offset _scaledOffset = Offset.zero;
  bool _showOffsetIndicator = false;

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

  void selectScreenScale(double scale) {
    final diffScale = (scale - this._currentScreenScale);
    this._currentScreenScale = scale;
    this._scaledOffset = Offset(
        (_currentOffset.dx * screenScale), (_currentOffset.dy * screenScale));
    this._currentOffset =
        Offset(_scaledOffset.dx / screenScale, _scaledOffset.dy / screenScale);
    notifyListeners();
  }

  void offsetChange(Offset delta) {
    this._scaledOffset = _scaledOffset + delta;
    this._currentOffset =
        Offset(_scaledOffset.dx / screenScale, _scaledOffset.dy / screenScale);
    notifyListeners();
  }

  void changeOffsetIndicator(bool show) {
    this._showOffsetIndicator = show;
    notifyListeners();
  }

  void resetScreenAdjustments(
      {DeviceInfo newDevice, MediaQueryData overrideData}) {
    this._currentOffset = Offset.zero;
    this._scaledOffset = Offset.zero;
    this._currentScreenScale = 1.0;
    if (newDevice != null) {
      this._currentDeviceSelected = newDevice;
    }
    if (overrideData != null) {
      this._currentMediaQuery = overrideData;
    }
    notifyListeners();
  }

  void toolbarHeightChanged(double height) {
    this._toolbarHeight = height;
    notifyListeners();
  }

  MediaQueryData get currentMediaQuery => _currentMediaQuery;

  MediaQueryData get boundedMediaQuery => _boundedMediaQuery;

  DeviceInfo get currentDevice => _currentDeviceSelected;

  double get screenScale => _currentScreenScale;

  Offset get currentOffset => _scaledOffset;

  bool get showOffsetIndicator => _showOffsetIndicator;

  bool get isAdjusted => currentOffset != Offset.zero || screenScale != 1.0;

  double get toolbarHeight => _toolbarHeight;
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

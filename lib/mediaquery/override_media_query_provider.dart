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
  double _bottomBarHeight = 0;

  /// this will be offset at scale 1.0
  Offset _currentOffset = Offset.zero;

  /// this will be used when changing scale, to represent offset as function
  /// of current.
  Offset _scaledOffset = Offset.zero;

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
    this._currentScreenScale = scale;
    this._scaledOffset = scaledOffsetCalculate();
    this._currentOffset = currentOffsetFromScale();
    notifyListeners();
  }

  Offset currentOffsetFromScale() =>
      Offset(_scaledOffset.dx / screenScale, _scaledOffset.dy / screenScale);

  Offset scaledOffsetCalculate() => Offset(
      (_currentOffset.dx * screenScale), (_currentOffset.dy * screenScale));

  void offsetChange(Offset delta) {
    this._scaledOffset = _scaledOffset + delta;
    this._currentOffset = currentOffsetFromScale();
    notifyListeners();
  }

  void resetScreenAdjustments(
      {DeviceInfo newDevice,
      MediaQueryData overrideData,
      MediaQueryData realQuery}) {
    if (newDevice != null) {
      this._currentDeviceSelected = newDevice;
    }
    if (overrideData != null) {
      this._currentMediaQuery = overrideData;
      this._boundedMediaQuery = overrideData;
    }
    // use this to adjust screen size to fit.
    if (realQuery != null && _currentDeviceSelected != DeviceSizes.window) {
      final widthRatio =
          realQuery.size.width / (boundedMediaQuery.size.width + 100);
      final heightRatio = viewPortHeightCalculate(realQuery.size.height) /
          (boundedMediaQuery.size.height + 100);
      if (widthRatio < 1 || heightRatio < 1) {
        if (widthRatio < heightRatio) {
          this._currentScreenScale = widthRatio;
        } else {
          this._currentScreenScale = heightRatio;
        }
      } else {
        this._currentScreenScale = 1.0;
      }
    } else {
      this._currentScreenScale = 1.0;
    }
    this._currentOffset = Offset(0, 0 - (bottomBarHeight / 2));
    this._scaledOffset = scaledOffsetCalculate();
    notifyListeners();
  }

  void toolbarHeightChanged(double height) {
    this._toolbarHeight = height;
    notifyListeners();
  }

  void bottomBarHeightChanged(double height) {
    this._bottomBarHeight = height;
    notifyListeners();
  }

  MediaQueryData get currentMediaQuery => _currentMediaQuery;

  MediaQueryData get boundedMediaQuery => _boundedMediaQuery;

  DeviceInfo get currentDevice => _currentDeviceSelected;

  double get screenScale => _currentScreenScale;

  Offset get currentOffset => _scaledOffset;

  double get toolbarHeight => _toolbarHeight;

  double get bottomBarHeight => _bottomBarHeight;

  double get viewportHeight {
    if (currentDevice != DeviceSizes.window) {
      return boundedMediaQuery.size.height;
    }
    return viewPortHeightCalculate(boundedMediaQuery.size.height);
  }

  double viewPortHeightCalculate(double height) =>
      height - toolbarHeight - bottomBarHeight - 48;

  double get viewportWidth => boundedMediaQuery.size.width;

  double get scaledWidth => boundedMediaQuery.size.width * _currentScreenScale;

  double get scaledHeight =>
      viewPortHeightCalculate(boundedMediaQuery.size.height * screenScale);

  double viewPortOffsetTop(MediaQueryData realQuery) =>
      (realQuery.size.height - boundedMediaQuery.size.height - toolbarHeight) /
      2;

  double viewPortOffsetLeft(MediaQueryData realQuery) =>
      (realQuery.size.width - boundedMediaQuery.size.width) / 2;
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

extension OverrideMediaQueryProviderExtension on BuildContext {
  OverrideMediaQueryProvider get mediaQueryProvider => mediaQuery(this);
}

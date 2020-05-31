import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:flutter_storybook/ui/utils/size+extensions.dart';
import 'package:provider/provider.dart';

class OverrideMediaQueryProvider extends ChangeNotifier {
  static const _paddingOffset = 48.0;

  MediaQueryData _currentMediaQuery;
  MediaQueryData _boundedMediaQuery;
  DeviceInfo _currentDeviceSelected;
  double _currentScreenScale = 1.0;
  double _toolbarHeight = 0;
  Size _pluginsSize = Size.zero;

  /// this will be offset at scale 1.0
  Offset _currentOffset = Offset.zero;

  /// this will be used when changing scale, to represent offset as function
  /// of current.
  Offset _scaledOffset = Offset.zero;

  Orientation _orientation = Orientation.portrait;

  OverrideMediaQueryProvider(this._currentDeviceSelected);

  void selectMediaQuery(MediaQueryData query) {
    // if landscape flip size when chosen
    _setMediaQuery(query);
    notifyListeners();
  }

  void _setMediaQuery(MediaQueryData query, [bool shouldFlip = false]) {
    if (!shouldFlip) {
      this._currentMediaQuery = query;
    } else {
      this._currentMediaQuery = query.copyWith(size: query.size.flipped);
    }
    this._boundedMediaQuery = _currentMediaQuery;
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

  void rotate(BuildContext context) {
    _orientation = _orientation == Orientation.portrait
        ? Orientation.landscape
        : Orientation.portrait;
    resetScreenAdjustments(
        realQuery: MediaQuery.of(context),
        overrideData: this.boundedMediaQuery,
        shouldFlip: true);
  }

  void resetScreenAdjustments(
      {DeviceInfo newDevice,
      MediaQueryData overrideData,
      MediaQueryData realQuery,
      Orientation overrideOrientation,
      bool shouldFlip = false}) {
    if (newDevice != null) {
      this._currentDeviceSelected = newDevice;
    }
    if (overrideOrientation != null) {
      this._orientation = overrideOrientation;
    }
    if (overrideData != null) {
      _setMediaQuery(overrideData, shouldFlip);
    }
    // use this to adjust screen size to fit.
    if (realQuery != null &&
        currentDevice.expansionAxis != ExpansionAxis.Both) {
      final deviceWidth = boundedMediaQuery.size.width;
      final deviceHeight = boundedMediaQuery.size.height;
      final realHeight = viewPortHeightCalculate(realQuery.size.height);
      final heightRatio = realHeight / (deviceHeight + _paddingOffset * 2);
      final realWidth = viewPortWidthCalculate(realQuery.size.width);
      final widthRatio = realWidth /
          (deviceWidth +
              (orientation == Orientation.landscape
                  ? (_paddingOffset * 2)
                  : 0));
      if (deviceHeight > deviceWidth) {
        // if calculated screen height taller than device height, set to 1.0
        if ((heightRatio * deviceWidth) > realWidth) {
          this._currentScreenScale = widthRatio;
        } else {
          this._currentScreenScale = heightRatio;
        }
      } else {
        // if calculated size going to be taller than real height, make it 1.0
        if ((widthRatio * deviceHeight) > realHeight) {
          this._currentScreenScale = heightRatio;
        } else {
          this._currentScreenScale = widthRatio;
        }
      }
    } else {
      this._currentScreenScale = 1.0;
    }
    this._currentOffset = Offset(0, toolbarHeight / 2);
    this._scaledOffset = scaledOffsetCalculate();
    notifyListeners();
  }

  void toolbarHeightChanged(double height) {
    this._toolbarHeight = height;
    notifyListeners();
  }

  void pluginsUISizeChanged(Size size) {
    this._pluginsSize = size;
    notifyListeners();
  }

  MediaQueryData get currentMediaQuery => _currentMediaQuery;

  MediaQueryData get boundedMediaQuery => _boundedMediaQuery;

  DeviceInfo get currentDevice => _currentDeviceSelected;

  double get screenScale => _currentScreenScale;

  Offset get currentOffset => _scaledOffset;

  double get toolbarHeight => _toolbarHeight;

  double get pluginsHeight => _pluginsSize.height;

  double get pluginsWidth => _pluginsSize.width;

  Size get pluginsSize => _pluginsSize;

  double get viewportHeight {
    if (!currentDevice.isExpandableHeight) {
      return boundedMediaQuery.size.height;
    }
    return viewPortHeightCalculate(boundedMediaQuery.size.height);
  }

  double viewPortHeightCalculate(double height) =>
      height - toolbarHeight - pluginsHeight - _paddingOffset;

  double viewPortWidthCalculate(double width) => width - pluginsWidth;

  double get viewportWidth {
    if (!currentDevice.isExpandableWidth) {
      return boundedMediaQuery.size.width;
    }
    return viewPortWidthCalculate(boundedMediaQuery.size.width);
  }

  Size get viewportSize => Size(viewportWidth, viewportHeight);

  double get scaledWidth => viewPortWidthCalculate(
      boundedMediaQuery.size.width * _currentScreenScale);

  double get scaledHeight =>
      viewPortHeightCalculate(boundedMediaQuery.size.height * screenScale);

  double viewPortOffsetTop(MediaQueryData realQuery) =>
      (realQuery.size.height - boundedMediaQuery.size.height - toolbarHeight) /
      2;

  double viewPortOffsetLeft(MediaQueryData realQuery) =>
      (realQuery.size.width - boundedMediaQuery.size.width - pluginsWidth) / 2;

  Orientation get orientation => _orientation;
}

OverrideMediaQueryProvider mediaQuery(BuildContext context) {
  final provider = Provider.of<OverrideMediaQueryProvider>(context);
  if (provider._currentMediaQuery == null) {
    provider._currentMediaQuery = MediaQuery.of(context);
    provider._boundedMediaQuery = provider._currentMediaQuery.copyWith(
      size: provider.currentDevice.logicalSize.boundedSize(context),
    );
  }
  // if expandable, we dont rotate, so we adjust its size everytime its needed.
  // in future it should be more efficient.
  if (provider.currentDevice.isExpandable) {
    provider._boundedMediaQuery = provider._currentMediaQuery.copyWith(
      size: provider.currentDevice.logicalSize.boundedSize(context),
    );
  }
  return provider;
}

extension OverrideMediaQueryProviderExtension on BuildContext {
  OverrideMediaQueryProvider get mediaQueryProvider => mediaQuery(this);
}

StoryBookPlugin overrideMediaQueryPlugin({DeviceInfo defaultDevice}) =>
    StoryBookPlugin(
      provider: ChangeNotifierProvider<OverrideMediaQueryProvider>(
        create: (context) =>
            OverrideMediaQueryProvider(defaultDevice ?? deviceSizes[0]),
      ),
    );

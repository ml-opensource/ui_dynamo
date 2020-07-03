import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ui_dynamo/plugins/plugin.dart';
import 'package:provider/provider.dart';

class OffsetProvider extends ChangeNotifier {
  /// this will be offset at scale 1.0
  Offset _currentOffset = Offset.zero;

  /// this will be used when changing scale, to represent offset as function
  /// of current.
  Offset _scaledOffset = Offset.zero;

  double _currentScreenScale = 1.0;

  void selectScreenScale(double scale, {Offset newOffset}) {
    if (newOffset != null) {
      _currentOffset = newOffset;
    }
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

  double get screenScale => _currentScreenScale;

  Offset get currentOffset => _scaledOffset;
}

extension OffsetPluginExtension on BuildContext {
  OffsetProvider get offsetProvider => Provider.of<OffsetProvider>(this);
}

DynamoPlugin offsetPlugin() => DynamoPlugin(
        provider: ChangeNotifierProvider<OffsetProvider>(
      create: (context) => OffsetProvider(),
    ));

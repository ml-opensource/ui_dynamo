import 'package:flutter/cupertino.dart';

class Range {
  final double min;
  final double max;
  final double step;
  final double currentValue;

  Range(
      {@required this.min,
      @required this.max,
      @required this.currentValue,
      this.step = 1});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Range &&
          runtimeType == other.runtimeType &&
          min == other.min &&
          max == other.max &&
          step == other.step &&
          currentValue == other.currentValue;

  @override
  int get hashCode =>
      min.hashCode ^ max.hashCode ^ step.hashCode ^ currentValue.hashCode;

  @override
  String toString() {
    return 'Range{min: $min, max: $max, step: $step, currentValue: $currentValue}';
  }

  Range copyWith({num min, num max, num step, num currentValue}) => Range(
      min: min ?? this.min,
      max: max ?? this.max,
      step: step ?? this.step,
      currentValue: currentValue ?? this.currentValue);
}

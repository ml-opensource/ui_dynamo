import 'package:flutter/cupertino.dart';

class PropGroup {
  final String label;
  final String groupId;

  const PropGroup(this.label, this.groupId);
}

typedef PropConstructor<T> = PropHandle<T> Function(
    String label, T value, String groupId);

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

abstract class PropHandle<T> {
  final String label;
  final T value;
  final String groupId;

  const PropHandle(this.label, this.value, this.groupId);

  String get textValue;
}

class TextPropHandle extends PropHandle<String> {
  static PropConstructor<String> propConstructor =
      (label, value, groupId) => TextPropHandle(label, value, groupId);

  const TextPropHandle(String label, String value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value;
}

class NumberPropHandle extends PropHandle<num> {
  static PropConstructor<num> propConstructor =
      (label, value, groupId) => NumberPropHandle(label, value, groupId);

  const NumberPropHandle(String label, num value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

class BooleanPropHandle extends PropHandle<bool> {
  static PropConstructor<bool> propConstructor =
      (label, value, groupId) => BooleanPropHandle(label, value, groupId);

  const BooleanPropHandle(String label, bool value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

class RangePropHandle extends PropHandle<Range> {
  static PropConstructor<Range> propConstructor =
      (label, value, groupId) => RangePropHandle(label, value, groupId);

  RangePropHandle(String label, Range value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

class PropValues<T> {
  final List<T> values;
  final T selectedValue;

  PropValues({@required this.values, @required this.selectedValue});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropValues &&
          runtimeType == other.runtimeType &&
          values == other.values &&
          selectedValue == other.selectedValue;

  @override
  int get hashCode => values.hashCode ^ selectedValue.hashCode;

  @override
  String toString() {
    return 'PropValues{values: $values, selectedValue: $selectedValue}';
  }

  PropValues<T> copyWith<T>({List<T> values, T selectedValue}) => PropValues<T>(
      values: values ?? this.values,
      selectedValue: selectedValue ?? this.selectedValue);
}

class PropValuesHandle<T> extends PropHandle<PropValues<T>> {
  static PropConstructor<dynamic> propConstructor = (label, value, groupId) =>
      PropValuesHandle<dynamic>(label, value, groupId);

  PropValuesHandle(String label, PropValues<T> value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

class RadioValuesHandle<T> extends PropHandle<PropValues<T>> {
  static PropConstructor<dynamic> propConstructor = (label, value, groupId) =>
      RadioValuesHandle<dynamic>(label, value, groupId);

  RadioValuesHandle(String label, PropValues<T> value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

/// Data object for convenience.
class InputProp {
  final String value;
  final ValueChanged<String> onChanged;

  InputProp(this.value, this.onChanged);
}

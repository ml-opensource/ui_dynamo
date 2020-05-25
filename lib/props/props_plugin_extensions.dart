import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/props/props_models.dart';
import 'package:flutter_storybook/props/props_plugin.dart';

extension PropsProviderConvenienceExtension on PropsProvider {
  /// Provides an [ValueProp] to use for text field convenience.
  /// The [value] is used to supply to an input field, while
  /// the [onChange] is used for convenience to send it back to the Props UI on
  /// change.
  ValueProp<String> textProp(String label, String defaultValue,
      {PropGroup group = defaultGroup}) {
    final value = text(label, defaultValue, group: group);
    return ValueProp<String>(
        value, (value) => textChanged(label, value, group.groupId));
  }

  /// Provides an [ValueProp] to use for [RadioListTile] field convenience.
  /// The [value] is used to supply to an input field, while
  /// the [onChange] is used for convenience to send it back to the Props UI on
  /// change.
  ValueProp<T> radioProp<T>(String label, PropValues<T> values,
      {PropGroup group = defaultGroup}) {
    final value = radios(label, values, group: group);
    return ValueProp<T>(
        value, (value) => radioChanged(label, value, group.groupId));
  }

  /// Provides an [ValueProp] to use for [Checkbox] field-like convenience.
  /// The [value] is used to supply to an input field, while
  /// the [onChange] is used for convenience to send it back to the Props UI on
  /// change.
  ValueProp<bool> booleanProp(String label, bool defaultValue,
      {PropGroup group = defaultGroup}) {
    final value = boolean(label, defaultValue, group: group);
    return ValueProp<bool>(
        value, (value) => booleanChanged(label, value, group.groupId));
  }
}

class ValueProp<T> {
  final T value;
  final ValueChanged<T> onChanged;

  ValueProp(this.value, this.onChanged);
}

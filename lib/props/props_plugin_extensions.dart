import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/props/props_models.dart';
import 'package:ui_dynamo/props/props_plugin.dart';

extension TwoWayBindingExtension on PropsProvider {
  TwoWayBindingGenerator get twoWay => TwoWayBindingGenerator(this);
}

/// Generates two-way bindings from [PropsProvider] to supply conveniences
/// for props and responding to actions on the UI.
class TwoWayBindingGenerator {
  final PropsProvider provider;

  TwoWayBindingGenerator(this.provider);

  /// Provides an [ValueProp] to use for text field convenience.
  /// The [value] is used to supply to an input field, while
  /// the [onChange] is used for convenience to send it back to the Props UI on
  /// change.
  ValueProp<String> text(String label, String defaultValue,
      {PropGroup group = defaultGroup}) {
    final value = provider.text(label, defaultValue, group: group);
    return ValueProp<String>(
        value, (value) => provider.textChanged(label, value, group.groupId));
  }

  /// Provides an [ValueProp] to use for [RadioListTile] field convenience.
  /// The [value] is used to supply to an input field, while
  /// the [onChange] is used for convenience to send it back to the Props UI on
  /// change.
  ValueProp<T> radio<T>(String label, PropValues<T> values,
      {PropGroup group = defaultGroup}) {
    final value = provider.radios(label, values, group: group);
    return ValueProp<T>(
        value, (value) => provider.radioChanged(label, value, group.groupId));
  }

  /// Provides an [ValueProp] to use for [Checkbox] field-like convenience.
  /// The [value] is used to supply to an input field, while
  /// the [onChange] is used for convenience to send it back to the Props UI on
  /// change.
  ValueProp<bool> boolean(String label, bool defaultValue,
      {PropGroup group = defaultGroup}) {
    final value = provider.boolean(label, defaultValue, group: group);
    return ValueProp<bool>(
        value, (value) => provider.booleanChanged(label, value, group.groupId));
  }
}

class ValueProp<T> {
  final T value;
  final ValueChanged<T> onChanged;

  ValueProp(this.value, this.onChanged);
}

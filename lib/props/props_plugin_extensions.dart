import 'package:flutter_storybook/flutter_storybook.dart';

extension PropsProviderConvenienceExtension on PropsProvider {
  /// Provides an [InputProp] to use for input field convenience.
  /// The [value] is used to supply to an input field, while
  /// the [onChange] is used for convenience to send it back to the Props UI on
  /// change.
  InputProp input(String label, String defaultValue,
      {PropGroup group = defaultGroup}) {
    final value = text(label, defaultValue, group: group);
    return InputProp(
        value, (value) => textChanged(label, value, group.groupId));
  }
}

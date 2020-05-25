import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final String errorText;
  final int maxCount;

  const AppInput({
    Key key,
    @required this.label,
    @required this.value,
    @required this.onChanged,
    this.errorText,
    this.maxCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        errorText: errorText,
        border: OutlineInputBorder(),
        labelText: label,
        counterText: maxCount != null ? "${value.length} / $maxCount" : null,
      ),
      maxLength: maxCount,
      controller: TextEditingController.fromValue(TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.toString().length))),
      onChanged: onChanged,
    );
  }
}

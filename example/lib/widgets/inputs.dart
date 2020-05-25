import 'package:flutter/material.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const AppInput({
    Key key,
    @required this.label,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      controller: TextEditingController.fromValue(TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.toString().length))),
      onChanged: onChanged,
    );
  }
}

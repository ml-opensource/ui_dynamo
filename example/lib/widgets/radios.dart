import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RadioGroup extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> valueChanged;

  const RadioGroup(
      {Key key, @required this.selectedValue, @required this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RadioListTile(
          value: "Yellow",
          groupValue: selectedValue,
          onChanged: _valueChanged,
          title: Text("Yellow"),
        ),
        RadioListTile(
          value: "Red",
          groupValue: selectedValue,
          onChanged: _valueChanged,
          title: Text("Red"),
        ),
        RadioListTile(
          value: "Green",
          groupValue: selectedValue,
          onChanged: _valueChanged,
          title: Text("Green"),
        ),
      ],
    );
  }

  void _valueChanged(value) {
    valueChanged(value);
  }
}

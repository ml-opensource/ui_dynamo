import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RadioGroup extends StatefulWidget {
  final String selectedValue;
  final ValueChanged<String> valueChanged;

  const RadioGroup(
      {Key key, @required this.selectedValue, @required this.valueChanged})
      : super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio(
          value: "Yellow",
          groupValue: widget.selectedValue,
          onChanged: widget.valueChanged,
        ),
        Radio(
          value: "Red",
          groupValue: widget.selectedValue,
          onChanged: widget.valueChanged,
        ),
        Radio(
          value: "Green",
          groupValue: widget.selectedValue,
          onChanged: widget.valueChanged,
        ),
      ],
    );
  }
}

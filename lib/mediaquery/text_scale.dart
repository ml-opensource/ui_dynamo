import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/utils/hold_detector.dart';

class TextScaleFactorWidget extends StatelessWidget {
  final double textScaleFactor;
  final Function(double) textScaleFactorChanged;

  const TextScaleFactorWidget(
      {Key key,
      this.textScaleFactor = 0.0,
      @required this.textScaleFactorChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HoldDetector(
          holdTimeout: Duration(milliseconds: 200),
          enableHapticFeedback: true,
          onHold: _incrementFactor,
          child: IconButton(
            icon: Icon(Icons.remove),
            onPressed: textScaleFactor > 0 ? () => _incrementFactor() : null,
          ),
        ),
        Icon(Icons.text_fields),
        Text("${textScaleFactor.toStringAsFixed(2)}"),
        HoldDetector(
          holdTimeout: Duration(milliseconds: 200),
          enableHapticFeedback: true,
          onHold: _decrementFactor,
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _decrementFactor(),
          ),
        )
      ],
    );
  }

  _decrementFactor() => textScaleFactorChanged(textScaleFactor + 0.1);

  _incrementFactor() => textScaleFactorChanged(textScaleFactor - 0.1);
}

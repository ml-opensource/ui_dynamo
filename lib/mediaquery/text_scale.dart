import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/utils/hold_detector.dart';

class AdjustableNumberScaleWidget extends StatelessWidget {
  final double scaleFactor;
  final Function(double) scaleFactorChanged;
  final IconData displayIcon;
  final String tooltip;

  const AdjustableNumberScaleWidget({
    Key key,
    this.scaleFactor = 0.0,
    @required this.scaleFactorChanged,
    this.displayIcon,
    @required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          HoldDetector(
            holdTimeout: Duration(milliseconds: 200),
            enableHapticFeedback: true,
            onHold: _incrementFactor,
            child: IconButton(
              icon: Icon(Icons.remove),
              onPressed: scaleFactor > 0 ? () => _incrementFactor() : null,
            ),
          ),
          if (this.displayIcon != null) Icon(this.displayIcon),
          Tooltip(
            message: 'Tap to set text scale factor back to 1',
            child: InkWell(
              child: Text("${scaleFactor.toStringAsFixed(2)}"),
              onTap: () => scaleFactorChanged(1.0),
            ),
          ),
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
      ),
    );
  }

  _decrementFactor() => scaleFactorChanged(scaleFactor + 0.1);

  _incrementFactor() => scaleFactorChanged(scaleFactor - 0.1);
}

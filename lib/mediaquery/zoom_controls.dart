import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/utils/hold_detector.dart';

class ZoomControls extends StatelessWidget {
  final Function(double) updateScale;
  final double scale;

  const ZoomControls(
      {Key key, @required this.updateScale, @required this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        HoldDetector(
          holdTimeout: Duration(milliseconds: 200),
          enableHapticFeedback: true,
          onHold: () => updateScale(scale - 0.05),
          child: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => updateScale(scale - 0.05),
          ),
        ),
        Tooltip(
          message: 'Tap to set back to 100% scale.',
          child: InkWell(
            child: Text('${(scale * 100).round()}%'),
            onTap: () => updateScale(1),
          ),
        ),
        HoldDetector(
          holdTimeout: Duration(milliseconds: 200),
          enableHapticFeedback: true,
          onHold: () => updateScale(scale + 0.05),
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => updateScale(scale + 0.05),
          ),
        ),
      ],
    );
  }
}

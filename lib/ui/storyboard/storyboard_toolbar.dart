import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/utils/hold_detector.dart';

class StoryboardToolbar extends StatelessWidget {
  final Function(double) updateScale;
  final double scale;

  const StoryboardToolbar(
      {Key key, @required this.updateScale, @required this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 65.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
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
              InkWell(
                child: Center(child: Text('${(scale * 100).round()}%')),
                onTap: () => updateScale(1),
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
          ),
        ),
      ],
    );
  }
}

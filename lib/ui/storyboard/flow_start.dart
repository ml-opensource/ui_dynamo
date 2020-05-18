import 'package:flutter/material.dart';

class FlowStart extends StatelessWidget {
  final String label;

  const FlowStart({
    Key key,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        child: Container(
          color: Colors.black,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 34.0,
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Flow'),
                  Text(label),
                  SizedBox(
                    height: 16,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 64.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ToastMode { Success, Error, Warning }

class AppToast extends StatelessWidget {
  final String message;
  final ToastMode toastMode;

  const AppToast(
      {Key key, @required this.message, this.toastMode = ToastMode.Success})
      : super(key: key);

  Icon iconForMode() {
    switch (toastMode) {
      case ToastMode.Error:
        return Icon(
          Icons.error,
          color: Colors.red,
        );
      case ToastMode.Warning:
        return Icon(
          Icons.warning,
          color: Colors.yellow,
        );
      case ToastMode.Success:
      default:
        return Icon(
          Icons.check_circle,
          color: Colors.green,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            iconForMode(),
          ],
        ),
      ),
    );
  }
}

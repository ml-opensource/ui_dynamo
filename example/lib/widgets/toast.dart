import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ToastMode { Success, Error, Warning }

class AppToast extends StatelessWidget {
  final String message;
  final ToastMode toastMode;
  final VoidCallback onClose;

  const AppToast(
      {Key key,
      @required this.message,
      this.onClose,
      this.toastMode = ToastMode.Success})
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
        padding: const EdgeInsets.only(
            left: 8.0, right: 16.0, top: 8.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: onClose,
            ),
            SizedBox(
              width: 16.0,
            ),
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

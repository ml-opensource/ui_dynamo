import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum ToastMode { Success, Error, Warning }

class AppToast extends StatelessWidget {
  final String message;
  final ToastMode toastMode;

  const AppToast(
      {Key key, @required this.message, this.toastMode = ToastMode.Success})
      : super(key: key);

  IconData iconForMode() {
    switch (toastMode) {
      case ToastMode.Error:
        return Icons.error;
      case ToastMode.Warning:
        return Icons.warning;
      case ToastMode.Success:
      default:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(message),
        Icon(iconForMode()),
      ],
    );
  }
}

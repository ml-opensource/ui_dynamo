import 'package:flutter/material.dart';

class NetworkAlertDialog extends StatelessWidget {
  final GestureTapCallback onOkPressed;

  const NetworkAlertDialog({Key key, this.onOkPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Network Error'),
      content: Text('Something went wrong'),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: onOkPressed,
        ),
      ],
    );
  }
}

class ConfirmationAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final GestureTapCallback onYesPressed;
  final GestureTapCallback onNoPressed;

  const ConfirmationAlertDialog(
      {Key key, this.title, this.content, this.onYesPressed, this.onNoPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          color: Theme.of(context).accentColor,
          onPressed: onYesPressed,
        ),
        FlatButton(
          child: Text('No'),
          onPressed: onNoPressed,
        ),
      ],
    );
  }
}

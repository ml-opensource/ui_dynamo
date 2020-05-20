import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildAlertsPage() => StoryBookPage.list(
  title: 'Alerts',
  icon: Icon(Icons.error),
  widgets: (context) => [
    Organization.expandable(
      initiallyExpanded: true,
      title: 'Network Alert',
      children: <Widget>[
        AlertDialog(
          title: Text('Network Error'),
          content: Text('Something went wrong'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: context.actions.onPressed('Alert Ok Button'),
            ),
          ],
        )
      ],
    ),
    Organization.expandable(
      initiallyExpanded: true,
      title: 'Confirmation Dialog',
      children: <Widget>[
        AlertDialog(
          title: Text('Are you sure you want to get Pizza?'),
          content: Text('You can always order later'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              color: Theme.of(context).accentColor,
              onPressed: context.actions.onPressed('Alert Yes Button'),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: context.actions.onPressed('Alert No Button'),
            ),
          ],
        )
      ],
    )
  ],
);

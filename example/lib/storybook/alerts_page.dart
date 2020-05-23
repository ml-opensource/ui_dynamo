import 'package:example/widgets/alerts.dart';
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
            NetworkAlertDialog(
              onOkPressed: context.actions.onPressed('Alert Ok Button'),
            ),
          ],
        ),
          Organization.expandable(
            initiallyExpanded: true,
            title: 'Confirmation Dialog',
            children: <Widget>[
              ConfirmationAlertDialog(
                title: 'Are you sure you want to get Pizza?',
                content: 'You can always order later',
                onYesPressed: context.actions.onPressed('Alert Yes Button'),
                onNoPressed: context.actions.onPressed('Alert No Button'),
              ),
            ],
          )
      ],
    );

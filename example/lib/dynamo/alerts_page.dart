import 'package:example/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:ui_dynamo/ui_dynamo.dart';

PropGroup confirmationGroup = PropGroup('Confirmation', 'confirmation');

DynamoPage buildAlertsPage() => DynamoPage.list(
      title: 'Alerts',
      icon: Icon(Icons.error),
      children: (context) => [
        Organization.container(
          title: Text('Network Alert'),
          children: <Widget>[
            NetworkAlertDialog(
              onOkPressed: context.actions.onPressed('Alert Ok Button'),
            ),
          ],
        ),
        Organization.container(
          title: Text('Confirmation Dialog'),
          children: <Widget>[
            ConfirmationAlertDialog(
              title: context.props.text(
                  'Title', 'Are you sure you want to get Pizza?',
                  group: confirmationGroup),
              content: context.props.text(
                  'Content', 'You can always order later',
                  group: confirmationGroup),
              onYesPressed: context.actions.onPressed('Alert Yes Button'),
              onNoPressed: context.actions.onPressed('Alert No Button'),
            ),
          ],
        )
      ],
    );

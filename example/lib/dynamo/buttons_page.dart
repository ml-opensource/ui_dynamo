import 'package:flutter/material.dart';
import 'package:ui_dynamo/ui_dynamo.dart';

DynamoPage buildButtonsPage() => DynamoPage.list(
      title: 'Button States',
      widgets: (context) {
        final prop = context.props;
        final action = context.actions;
        return [
          Organization.container(
            title: Text('Buttons'),
            children: [
              StyledText.body(Text(
                  'Buttons in our application follow a few kinds of buttons')),
            ],
          ),
          Organization.container(
            title: Text('Primary'),
            children: [
              RaisedButton(
                onPressed: action.onPressed('Primary'),
                child: Text(
                    prop.text('Text', 'Yes', group: PropGroup('Primary', 'p'))),
              ),
              StyledText.body(Text('Use this button for main actions.')),
            ],
          ),
          Organization.container(
            title: Text('Primary Wide'),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  onPressed: action.onPressed('Primary Wide'),
                  child: Text(prop.text('Text', 'View All',
                      group: PropGroup('Primary Wide', 'pw'))),
                ),
              ),
              StyledText.body(
                  Text('This button is used for a very important CTA.')),
            ],
          ),
          Organization.container(
            title: Text('Secondary'),
            children: [
              OutlineButton(
                onPressed: action.onPressed('Secondary'),
                child: Text(prop.text('Text', 'Cancel',
                    group: PropGroup('Secondary', 's'))),
              ),
              StyledText.body(
                Text(
                    'Use this button for actions that are cancel-like or unsuggested routes.'),
              )
            ],
          ),
          Organization.container(
            title: Text('Disabled'),
            children: [
              RaisedButton(
                onPressed: null,
                child: Text('Save'),
              ),
              StyledText.body(Text('When the button should be disabled')),
            ],
          )
        ];
      },
    );

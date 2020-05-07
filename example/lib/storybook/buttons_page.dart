import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildButtonsPage() => StoryBookPage.list(
      title: 'Button States',
      widgets: (context) {
        final prop = props(context);
        final action = actions(context);
        return [
          WidgetContainer(
            title: Text('Buttons'),
            children: [
              StyledText.body(Text(
                  'Buttons in our application follow a few kinds of buttons')),
            ],
          ),
          WidgetContainer(
            title: Text('Primary'),
            children: [
              RaisedButton(
                onPressed: action.onPressed('Primary'),
                child: Text(prop.text('Text', 'Yes',
                    group: PropGroup('Primary', 'p'))),
              ),
              StyledText.body(Text('Use this button for main actions.')),
            ],
          ),
          WidgetContainer(
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
              StyledText.body(Text('This button is used for a very important CTA.')),
            ],
          ),
          WidgetContainer(
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
          WidgetContainer(
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

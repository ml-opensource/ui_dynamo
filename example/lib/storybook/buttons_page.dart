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
              Text('Buttons in our application follow a few kinds of buttons'),
            ],
          ),
          WidgetContainer(
            title: Text('Primary'),
            children: [
              RaisedButton(
                onPressed: action.onPressed('Primary'),
                child: Text(prop.text('Text', 'Primary',
                    group: PropGroup('Primary', 'p'))),
              ),
              Text('Use this button for main actions.'),
            ],
          ),
          WidgetContainer(
            title: Text('Secondary'),
            children: [
              OutlineButton(
                onPressed: action.onPressed('Secondary'),
                child: Text(prop.text('Text', 'Secondary',
                    group: PropGroup('Secondary', 's'))),
              ),
              Text(
                  'Use this button for actions that are cancel-like or unsuggested routes.')
            ],
          ),
          WidgetContainer(
            title: Text('Disabled'),
            children: [
              RaisedButton(
                onPressed: null,
                child: Text('Disabled'),
              ),
              Text('When the button should be disabled'),
            ],
          )
        ];
      },
    );

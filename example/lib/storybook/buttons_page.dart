import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildButtonsPage() => StoryBookPage.list(
      title: 'Button States',
      widgets: (context) => [
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
              onPressed: actions(context).onPressed('Primary'),
              child: Text('Primary'),
            ),
          ],
        ),
        WidgetContainer(
          title: Text('Secondary'),
          children: [
            OutlineButton(
              onPressed: actions(context).onPressed('Secondary'),
              child: Text('Secondary'),
            ),
          ],
        ),
        WidgetContainer(
          title: Text('Disabled'),
          children: [
            RaisedButton(
              onPressed: null,
              child: Text('Disabled'),
            ),
          ],
        )
      ],
    );

import 'package:example/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';

StoryBookPage buildToastPage() => StoryBookPage.list(
      title: 'Toasts',
      icon: Icon(Icons.check_circle),
      widgets: (context) {
        final currentMediaQuery = mediaQuery(context).currentMediaQuery;
        final isLight =
            currentMediaQuery.platformBrightness == Brightness.light;
        final successPropGroup = PropGroup('Success', '');
        final errorPropGroup = PropGroup('Error', 'e');
        final warningPropGroup = PropGroup('Warning', 'w');
        return [
          WidgetContainer(
            title: Text('Toast'),
            children: <Widget>[
              StyledText.body(Text(
                  'Toast is used to display messages to the user in the UI')),
            ],
          ),
          WidgetContainer(
            title: Text('Success Toast'),
            cardBackgroundColor: isLight ? Colors.grey : Colors.green,
            children: [
              SizedBox(
                height: 16,
              ),
              AppToast(
                onClose: actions(context).onPressed('Close Toast'),
                message: props(context)
                    .text('Message', 'Success!', group: successPropGroup),
                toastMode: props(context).valueSelector(
                  'Mode',
                  PropValues<ToastMode>(
                    selectedValue: ToastMode.Success,
                    values: ToastMode.values,
                  ),
                  group: successPropGroup,
                ),
              ),
            ],
          ),
          WidgetContainer(
            title: Text('Error Toast'),
            cardBackgroundColor: isLight ? Colors.grey : Colors.red,
            children: [
              AppToast(
                onClose: actions(context).onPressed('Close Toast 2'),
                message: props(context).text(
                    'Message', 'Failure to reach network.',
                    group: errorPropGroup),
                toastMode: props(context).radios(
                  'Toast Mode 2',
                  PropValues<ToastMode>(
                    selectedValue: ToastMode.Error,
                    values: ToastMode.values,
                  ),
                  group: errorPropGroup,
                ),
              ),
            ],
          ),
          WidgetContainer(
            title: Text('Warning Toast'),
            cardBackgroundColor: isLight ? Colors.grey : Colors.red,
            children: [
              AppToast(
                onClose: actions(context).onPressed('Close Toast 2'),
                message: props(context).text(
                    'Message', 'There might be an issue with that.',
                    group: warningPropGroup),
                toastMode: props(context).radios(
                  'Toast Mode 2',
                  PropValues<ToastMode>(
                    selectedValue: ToastMode.Warning,
                    values: ToastMode.values,
                  ),
                  group: warningPropGroup,
                ),
              ),
            ],
          ),
          PresentationWidget(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StyledText.body(
              Text(
                  "Toast is a powerful widget that displays a status notification in the UI."),
            ),
          )),
          PropTable(
            items: [
              PropTableItem(
                  name: 'Message',
                  description: 'Displays a message for this toast'),
              PropTableItem(
                name: 'Mode',
                description: 'Displays a different UI mode',
                defaultValue: ToastMode.Success.toString(),
              ),
              PropTableItem(
                name: 'OnClose',
                description: 'Closes the Toast before the scheduled timeout',
                defaultValue: 'null',
              ),
            ],
          ),
        ];
      },
    );

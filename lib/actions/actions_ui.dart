import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/ui/styles/text_styles.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Renders the current actions on screen that come in as a list.
///
class ActionsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ActionsProvider>(
        builder: (context, actions, child) {
          final actionsList = actions.actionsList;
          if (actionsList.length == 0) {
            return EmptyToolbarView(
              text: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text:
                            'No Actions Found. Start by adding them using the'),
                    TextSpan(
                        text: 'context.actions extension.',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                  style: bodyStyle,
                ),
              ),
            );
          }
          return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    height: 1,
                  ),
              itemCount: actionsList.length,
              itemBuilder: (context, index) =>
                  ActionLabel(action: actionsList[index]));
        },
      ),
    );
  }
}

/// displays a single action.
class ActionLabel extends StatelessWidget {
  final ActionType action;

  const ActionLabel({
    Key key,
    @required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(action.icon),
        title: Text(action.name),
        trailing: Text(DateFormat.jms().format(action.time)),
        subtitle:
            action.data != null ? Text("Data ${action.data}") : Text("No Data"),
      ),
    );
  }
}

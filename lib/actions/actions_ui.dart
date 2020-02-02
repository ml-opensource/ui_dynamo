import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:provider/provider.dart';

class ActionsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ActionsProvider>(
        builder: (context, actions, child) {
          final actionsList = actions.actionsList;
          return ListView.builder(
              itemCount: actionsList.length,
              itemBuilder: (context, index) {
                final action = actionsList[index];
                return ActionLabel(action: action);
              });
        },
      ),
    );
  }
}

class ActionLabel extends StatelessWidget {
  const ActionLabel({
    Key key,
    @required this.action,
  }) : super(key: key);

  final ActionType action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(action.name),
        subtitle: Text("Data ${action.data}"),
      ),
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ActionType {
  final String name;
  final Object data;

  ActionType(this.name, {this.data});

  @override
  String toString() {
    return '$name: data=> $data';
  }
}

class ActionsProvider extends ChangeNotifier {
  final List<ActionType> actionsList = [];

  void add(ActionType actionType) {
    actionsList.insert(0, actionType);
    notifyListeners();
  }

  void reset() {
    actionsList.clear();
    notifyListeners();
  }

  GestureTapCallback onPressed(String buttonName) {
    return () => this.add(ActionType('Tap $buttonName'));
  }
}

ActionsProvider actions(BuildContext context) =>
    Provider.of<ActionsProvider>(context);

extension on BuildContext {
  ActionsProvider get actions => Provider.of<ActionsProvider>(this);
}

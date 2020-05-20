import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ActionType {
  final String name;
  final Object data;
  final DateTime time;

  ActionType(this.name, {this.data, DateTime time})
      : this.time = time ?? DateTime.now();

  @override
  String toString() {
    return 'ActionType{name: $name, data: $data, time: $time}';
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
    return () => this.add(ActionType('$buttonName: Tap'));
  }

  ValueChanged<T> valueChanged<T>(String widgetName) {
    return (value) => this.add(ActionType('$widgetName: Value changed $value'));
  }
}

ActionsProvider actions(BuildContext context) =>
    Provider.of<ActionsProvider>(context);

extension ActionProviderExtension on BuildContext {
  ActionsProvider get actions => Provider.of<ActionsProvider>(this);
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/plugins/safe_provider.dart';
import 'package:provider/provider.dart';

/// Represents an Action. Name is required. Data will be stringified and time
/// is used (if specified) to mark what time it executed at.
class ActionType {
  final String name;
  final Object data;
  final DateTime time;
  final IconData icon;

  ActionType(this.name, {this.data, DateTime time, this.icon})
      : this.time = time ?? DateTime.now();

  @override
  String toString() {
    return 'ActionType{name: $name, data: $data, time: $time}';
  }
}

/// This gets injected by the Actions plugin.
class ActionsProvider extends ChangeNotifier {
  final List<ActionType> actionsList = [];

  /// Looks up the [ActionsProvider] in  the current build context. Utilize
  /// the helpful extension on [BuildContext] imported in this file.
  factory ActionsProvider.of(BuildContext context) =>
      Provider.of<ActionsProvider>(context);

  ActionsProvider();

  /// Add an event at the beginning of the [actionsList].
  void add(ActionType actionType) {
    actionsList.insert(0, actionType);
    notifyListeners();
  }

  /// Clears and notifies listeners.
  void reset() {
    actionsList.clear();
    notifyListeners();
  }

  /// Utilize this as the stub to your onTap callbacks. Returns a [GestureTapCallback]
  /// to use in Stories. When tapped, will trigger an ActionType.
  /// [through] is useful for supplying a further [GestureTapCallback].
  GestureTapCallback onPressed(String buttonName,
          {GestureTapCallback through}) =>
      () {
        this.add(ActionType('Tap -> $buttonName', icon: Icons.touch_app));
        through?.call();
      };

  /// Utilize this for handling value change events from a [RadioListTile]
  /// or other widgets that use it.
  /// [through] is useful for supplying a further [ValueChanged<T>].
  ValueChanged<T> valueChanged<T>(String widgetName,
          {ValueChanged<T> through}) =>
      (value) {
        this.add(ActionType('Value Changed -> $widgetName',
            data: value, icon: Icons.track_changes));
        through?.call(value);
      };
}

/// Helpful extension to get the current [ActionsProvider] from the [BuildContext]
extension ActionProviderExtension on BuildContext {
  ActionsProvider get actions => ActionsProvider.of(this);

  ActionsProvider get safeActions => SafeProvider.of<ActionsProvider>(this);
}

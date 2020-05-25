import 'package:flutter/material.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:flutter_storybook/plugins/safe_provider.dart';
import 'package:flutter_storybook/props/props_models.dart';
import 'package:flutter_storybook/props/props_ui.dart';
import 'package:provider/provider.dart';

StoryBookPlugin propsPlugin() => StoryBookPlugin<PropsProvider>(
      provider: ChangeNotifierProvider(create: (context) => PropsProvider()),
      bottomTabText: 'Props',
      bottomTabPane: (context) => PropsDisplay(),
    );

const defaultGroupId = '';
const defaultGroup = PropGroup('', defaultGroupId);

class PropsProvider extends ChangeNotifier {
  factory PropsProvider.of(BuildContext context) =>
      Provider.of<PropsProvider>(context);

  final Map<PropGroup, List<PropHandle>> props = {};

  PropsProvider();

  /// Returns a flat [List] where each [PropGroup] key interwoven
  /// with [PropHandle] lists.
  List propsAndGroups() {
    final propsAndGroups = [];
    props.forEach((key, value) {
      if (key != defaultGroup) {
        propsAndGroups.add(key);
      }
      propsAndGroups.addAll(value);
    });
    return propsAndGroups;
  }

  /// Retrieves a prop after finding the group by [groupId].
  PropHandle<T> _retrieveProp<T>(String label,
      [String groupId = defaultGroupId]) {
    PropGroup group = _findGroupById(groupId);
    return _retrievePropByGroup(label, group);
  }

  /// Looks up a [PropHandle] by [label]. If the label changes, the prop will no
  /// longer exist potentially.
  PropHandle<T> _retrievePropByGroup<T>(String label, PropGroup group) {
    if (group != null) {
      final prop = props[group];
      return prop.firstWhere((element) => element.label == label,
          orElse: () => null);
    }
    return null;
  }

  /// Looks up a [PropGroup] by id.
  PropGroup _findGroupById(String groupId) {
    final group = props.keys.firstWhere((element) => element.groupId == groupId,
        orElse: () => null);
    return group;
  }

  /// Retrieves or adds a group depending on if it exists in list.
  PropGroup _retrieveOrAddGroup(PropGroup propGroup) {
    if (propGroup == null) {
      return defaultGroup;
    }
    final group = _findGroupById(propGroup.groupId);
    if (group != null) {
      return group;
    } else {
      props[propGroup] = [];
      return propGroup;
    }
  }

  /// call to clear prop handles. This is done per page.
  void reset() {
    props.clear();
    notifyListeners();
  }

  /// Called when value changes. For internal use, and replaces
  /// the prop handle on every change.
  void _valueChanged<T>(
      PropHandle<T> prop, PropConstructor<T> propConstructor, T newValue) {
    final group = _findGroupById(prop.groupId);
    final existing = _retrievePropByGroup(prop.label, group);
    final propsList = props[group];
    final propHandle = propConstructor(prop.label, newValue, prop.groupId);
    if (existing == null) {
      propsList.add(propHandle);
    } else {
      final indexOf = propsList.indexOf(existing);
      propsList.replaceRange(indexOf, indexOf + 1, [propHandle]);
    }
    notifyListeners();
  }

  /// Called when text changes from Props UI. For internal use.
  void textChangedByProp(PropHandle prop, String newValue) {
    _valueChanged<String>(prop, TextPropHandle.propConstructor, newValue);
  }

  /// Called when number changes from Props UI. For internal use.
  void numberChangedByProp(PropHandle prop, num newValue) {
    _valueChanged<num>(prop, NumberPropHandle.propConstructor, newValue);
  }

  /// Called when boolean changes from Props UI. For internal use.
  void booleanChangedByProp(BooleanPropHandle prop, bool newValue) {
    _valueChanged(prop, BooleanPropHandle.propConstructor, newValue);
  }

  /// Called when Range changes from Props UI. For internal use.
  void rangeChangedByProp(RangePropHandle prop, double newValue) {
    _valueChanged(prop, RangePropHandle.propConstructor,
        prop.value.copyWith(currentValue: newValue));
  }

  /// Called when value changes from Props UI. For internal use.
  void valueChangedByProp<T>(PropValuesHandle<T> prop, T newValue) {
    _valueChanged(prop, PropValuesHandle.propConstructor,
        prop.value.copyWith(selectedValue: newValue));
  }

  /// Called when radio changes from Props UI. For internal use.
  void radioChangedByProp<T>(RadioValuesHandle<T> prop, T newValue) {
    _valueChanged(prop, RadioValuesHandle.propConstructor,
        prop.value.copyWith(selectedValue: newValue));
  }

  /// Called when a [Radio] changes. Use this in a [RadioGroup] to introduce
  /// bidirectionality when changing the value from the main UI instead of from
  /// the Props UI.
  void radioChanged<T>(String label, T newValue,
      [String groupId = defaultGroupId]) {
    final prop = _retrieveProp<dynamic>(label, groupId);
    if (prop is RadioValuesHandle<dynamic>) {
      radioChangedByProp<dynamic>(prop, newValue);
    }
  }

  void textChanged(String label, String newValue,
      [String groupId = defaultGroupId]) {
    final prop = _retrieveProp<String>(label, groupId);
    if (prop is TextPropHandle) {
      textChangedByProp(prop, newValue);
    }
  }

  /// Adds or retrieves a value from the underlying props data.
  /// This is not strictly safe, though surface methods handle the type-safety.
  dynamic _addOrRetrieveValue<T>(String label, T defaultValue,
      PropConstructor<T> propConstructor, PropGroup group) {
    final retrievedGroup = _retrieveOrAddGroup(group ?? defaultGroup);
    final existing = _retrievePropByGroup<dynamic>(label, retrievedGroup);
    if (existing == null) {
      props[retrievedGroup]
          .add(propConstructor(label, defaultValue, retrievedGroup?.groupId));
      return defaultValue;
    } else {
      return existing.value;
    }
  }

  /// Constructs [TextPropHandle] to fill a [String] property field. In the props
  /// UI this is a [TextField].
  /// Specify a [PropGroup] to group each prop in the UI. By default, fills the
  /// default group.
  String text(String label, String defaultValue, {PropGroup group}) =>
      _addOrRetrieveValue(
          label, defaultValue, TextPropHandle.propConstructor, group);

  /// Constructs [NumberPropHandle] to fill a [num] property field. In the props
  /// UI this is a [TextField] of type [TextInputType.number].
  /// Specify a [PropGroup] to group each prop in the UI. By default, fills the
  /// default group.
  num number(String label, num defaultValue, {PropGroup group}) =>
      _addOrRetrieveValue(
          label, defaultValue, NumberPropHandle.propConstructor, group);

  /// Constructs [NumberPropHandle] to fill a [num] property field as an [int].
  /// In the props UI this is a [TextField] of type [TextInputType.number].
  /// Specify a [PropGroup] to group each prop in the UI. By default, fills the
  /// default group.
  int integer(String label, int defaultValue, {PropGroup group}) =>
      number(label, defaultValue, group: group).toInt();

  /// Constructs [BooleanPropHandle] to fill a [bool] property field. In the
  /// props UI this is a [Checkbox].
  /// Specify a [PropGroup] to group each prop in the UI. By default, fills the
  /// default group.
  bool boolean(String label, bool defaultValue, {PropGroup group}) =>
      _addOrRetrieveValue(
          label, defaultValue, BooleanPropHandle.propConstructor, group);

  /// Constructs [RangePropHandle] to fill a [Range] property field for a
  /// range slider value. In the props UI this is a [RangeSlider].
  /// Specify a [PropGroup] to group each prop in the UI. By default, fills the
  /// default group.
  double range(String label, Range defaultRange, {PropGroup group}) =>
      _addOrRetrieveValue(
              label, defaultRange, RangePropHandle.propConstructor, group)
          .currentValue;

  /// Constructs [PropValuesHandle] to fill a [T] property field. In the props UI
  /// this is a [DropdownButton] with selector options. Specify a [PropGroup]
  /// to group each prop in the UI. By default, fills the default group.
  T valueSelector<T>(String label, PropValues<T> defaultValues,
          {PropGroup group}) =>
      _addOrRetrieveValue<dynamic>(
              label, defaultValues, PropValuesHandle.propConstructor, group)
          .selectedValue;

  /// Constructs [RadioValuesHandle] to fill a [T] property field. In the props UI
  /// this is a List of [RadioListTile] with selector options. Specify a [PropGroup]
  /// to group each prop in the UI. By default, fills the default group.
  T radios<T>(String label, PropValues<T> defaultValues, {PropGroup group}) =>
      _addOrRetrieveValue<dynamic>(
              label, defaultValues, RadioValuesHandle.propConstructor, group)
          .selectedValue;
}

extension PropsProviderExtension on BuildContext {
  PropsProvider get props => Provider.of<PropsProvider>(this);

  PropsProvider get safeProps => SafeProvider.of<PropsProvider>(this);
}

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_storybook/props/props_models.dart';
import 'package:provider/provider.dart';

class PropGroup {
  final String label;
  final String groupId;

  const PropGroup(this.label, this.groupId);
}

typedef PropConstructor<T> = PropHandle<T> Function(
    String label, T value, String groupId);

const _defaultGroupId = '';
const _defaultGroup = PropGroup('', _defaultGroupId);

class PropsProvider extends ChangeNotifier {
  final Map<PropGroup, List<PropHandle>> props = {};

  List propsAndGroups() {
    final propsAndGroups = [];
    props.forEach((key, value) {
      if (key != _defaultGroup) {
        propsAndGroups.add(key);
      }
      propsAndGroups.addAll(value);
    });
    return propsAndGroups;
  }

  PropHandle<T> retrieveProp<T>(String label,
      [String groupId = _defaultGroupId]) {
    PropGroup group = findGroupById(groupId);
    if (group != null) {
      return props[group]
          .firstWhere((element) => element.label == label, orElse: () => null);
    }
    return null;
  }

  PropHandle<T> retrievePropByGroup<T>(String label, PropGroup group) {
    if (group != null) {
      final prop = props[group];
      return prop.firstWhere((element) => element.label == label,
          orElse: () => null);
    }
    return null;
  }

  PropGroup findGroupById(String groupId) {
    final group = props.keys.firstWhere((element) => element.groupId == groupId,
        orElse: () => null);
    return group;
  }

  PropGroup retrieveOrAddGroup(PropGroup propGroup) {
    if (propGroup == null) {
      return _defaultGroup;
    }
    final group = findGroupById(propGroup.groupId);
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

  void _valueChanged<T>(
      PropHandle<T> prop, PropConstructor<T> propConstructor, T newValue) {
    final group = findGroupById(prop.groupId);
    final existing = retrievePropByGroup(prop.label, group);
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

  void textChanged(PropHandle prop, String newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => TextPropHandle(label, value, groupId),
        newValue);
  }

  void numberChanged(PropHandle prop, num newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => NumberPropHandle(label, value, groupId),
        newValue);
  }

  void booleanChanged(BooleanPropHandle prop, bool newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => BooleanPropHandle(label, value, groupId),
        newValue);
  }

  void rangeChanged(RangePropHandle prop, double newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => RangePropHandle(label, value, groupId),
        prop.value.copyWith(currentValue: newValue));
  }

  void valueChanged<T>(PropValuesHandle<T> prop, T newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => PropValuesHandle<T>(label, value, groupId),
        prop.value.copyWith(selectedValue: newValue));
  }

  void radioChanged<T>(String label, T newValue,
      [String groupId = _defaultGroupId]) {
    final prop = retrieveProp<dynamic>(label, groupId);
    if (prop is RadioValuesHandle<dynamic>) {
      radioChangedByProp<dynamic>(prop, newValue);
    }
  }

  void radioChangedByProp<T>(RadioValuesHandle<T> prop, T newValue) {
    _valueChanged(
        prop,
        (label, value, groupId) => RadioValuesHandle<T>(label, value, groupId),
        prop.value.copyWith(selectedValue: newValue));
  }

  dynamic _value<T>(String label, T defaultValue, PropConstructor<T> propConstructor,
      PropGroup group) {
    final retrievedGroup = retrieveOrAddGroup(group ?? _defaultGroup);
    final existing = retrievePropByGroup<dynamic>(label, retrievedGroup);
    if (existing == null) {
      props[retrievedGroup]
          .add(propConstructor(label, defaultValue, retrievedGroup?.groupId));
      return defaultValue;
    } else {
      return existing.value;
    }
  }

  String text(String label, String defaultValue, {PropGroup group}) => _value(
      label,
      defaultValue,
      (label, value, groupId) => TextPropHandle(label, value, groupId),
      group);

  num number(String label, num defaultValue, {PropGroup group}) => _value(
      label,
      defaultValue,
      (label, value, groupId) => NumberPropHandle(label, value, groupId),
      group);

  int integer(String label, int defaultValue, {PropGroup group}) =>
      number(label, defaultValue, group: group).toInt();

  bool boolean(String label, bool defaultValue, {PropGroup group}) => _value(
      label,
      defaultValue,
      (label, value, groupId) => BooleanPropHandle(label, value, groupId),
      group);

  /// Builds a range slider.
  double range(String label, Range defaultRange, {PropGroup group}) => _value(
          label,
          defaultRange,
          (label, value, groupId) => RangePropHandle(label, value, groupId),
          group)
      .currentValue;

  T valueSelector<T>(String label, PropValues<T> defaultValues,
          {PropGroup group}) =>
      _value<dynamic>(
              label,
              defaultValues,
              (label, value, groupId) =>
                  PropValuesHandle<dynamic>(label, value, groupId),
              group)
          .selectedValue;

  T radios<T>(String label, PropValues<T> defaultValues, {PropGroup group}) =>
      _value<dynamic>(
              label,
              defaultValues,
              (label, value, groupId) =>
                  RadioValuesHandle<dynamic>(label, value, groupId),
              group)
          .selectedValue;
}

PropsProvider props(BuildContext context) =>
    Provider.of<PropsProvider>(context);

extension on BuildContext {
  PropsProvider get props => Provider.of<PropsProvider>(this);
}

import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_storybook/props/props_models.dart';
import 'package:provider/provider.dart';

abstract class PropHandle<T> {
  final String label;
  final T value;
  final String groupId;

  const PropHandle(this.label, this.value, this.groupId);

  String get textValue;
}

class TextPropHandle extends PropHandle<String> {
  const TextPropHandle(String label, String value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value;
}

class NumberPropHandle extends PropHandle<num> {
  const NumberPropHandle(String label, num value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

class BooleanPropHandle extends PropHandle<bool> {
  const BooleanPropHandle(String label, bool value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

class RangePropHandle extends PropHandle<Range> {
  RangePropHandle(String label, Range value, String groupId)
      : super(label, value, groupId);

  @override
  String get textValue => value.toString();
}

class PropGroup {
  final String label;
  final String groupId;

  const PropGroup(this.label, this.groupId);
}

class PropsProvider extends ChangeNotifier {
  final List<PropHandle> props = [];
  final List<PropGroup> groups = [];

  List propAndGroups() {
    List propGroups = [];
    PropGroup currentGroup;
    props.forEach((element) {
      final foundGroup = retrieveGroupById(element.groupId);
      if (foundGroup != null && foundGroup != currentGroup) {
        propGroups.add(foundGroup);
        currentGroup = foundGroup;
      }
      propGroups.add(element);
    });
    return propGroups;
  }

  PropHandle retrievePropByLabel(String label) =>
      props.firstWhere((element) => element.label == label, orElse: () => null);

  PropGroup retrieveGroupById(String groupId) => groups
      .firstWhere((element) => element.groupId == groupId, orElse: () => null);

  PropGroup retrieveOrAddGroup(PropGroup propGroup) {
    if (propGroup == null) {
      return propGroup;
    }
    final group = groups.firstWhere(
        (element) => element.groupId == propGroup.groupId,
        orElse: () => null);
    if (group != null) {
      return group;
    } else {
      groups.add(propGroup);
      return propGroup;
    }
  }

  void add(PropHandle prop) {
    props.add(prop);
    notifyListeners();
  }

  /// call to clear prop handles. This is done per page.
  void reset() {
    props.clear();
    notifyListeners();
  }

  void _valueChanged<T>(
      PropHandle<T> prop,
      Function(String label, T value, String groupId) propConstructor,
      T newValue) {
    final existing = retrievePropByLabel(prop.label);
    if (existing == null) {
      props.add(propConstructor(prop.label, newValue, prop.groupId));
    } else {
      final indexOf = props.indexOf(existing);
      props.replaceRange(indexOf, indexOf + 1,
          [propConstructor(prop.label, newValue, prop.groupId)]);
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

  T _value<T>(
      String label,
      T defaultValue,
      Function(String label, T value, String groupId) propConstructor,
      PropGroup group) {
    final existing = retrievePropByLabel(label);
    final retrievedGroup = retrieveOrAddGroup(group);
    if (existing == null) {
      props.add(propConstructor(label, defaultValue, retrievedGroup?.groupId));
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
}

PropsProvider props(BuildContext context) =>
    Provider.of<PropsProvider>(context);

extension on BuildContext {
  PropsProvider get props => Provider.of<PropsProvider>(this);
}

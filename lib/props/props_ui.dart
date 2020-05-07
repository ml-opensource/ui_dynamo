import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:provider/provider.dart';

class PropsDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<PropsProvider>(
        builder: (context, props, child) {
          final propsList = props.propsAndGroups();
          if (propsList.length == 0) {
            return EmptyToolbarView(
              text: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'No Props Found. Start by adding them using '),
                    TextSpan(
                        text: 'props(context)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            );
          }
          final maxWidth = BoxConstraints.loose(Size.fromWidth(350));
          return ListView.separated(
              padding: EdgeInsets.all(16.0),
              separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
              itemCount: propsList.length,
              itemBuilder: (context, index) {
                final prop = propsList[index];
                if (prop is PropGroup) {
                  return GroupLabel(group: prop);
                }
                if (prop is TextPropHandle) {
                  return EditablePropField(
                    maxWidth: maxWidth,
                    prop: prop,
                    textChanged: props.textChanged,
                  );
                } else if (prop is NumberPropHandle) {
                  return EditablePropField(
                    maxWidth: maxWidth,
                    prop: prop,
                    textChanged: (prop, text) {
                      props.numberChanged(prop, num.parse(text));
                    },
                  );
                } else if (prop is BooleanPropHandle) {
                  return CheckablePropField(
                    checkboxChanged: (prop, value) {
                      props.booleanChanged(prop, value);
                    },
                    maxWidth: maxWidth,
                    prop: prop,
                  );
                } else if (prop is RangePropHandle) {
                  return RangePropField(
                    prop: prop,
                    rangeChanged: (prop, value) {
                      props.rangeChanged(prop, value);
                    },
                  );
                } else if (prop is PropValuesHandle) {
                  return ValueSelectorField(
                    prop: prop,
                    valueChanged: (prop, value) {
                      props.valueChanged(prop, value);
                    },
                  );
                } else if (prop is RadioValuesHandle) {
                  return RadioSelectorField(
                    prop: prop,
                    valueChanged: (prop, value) {
                      props.radioChangedByProp(prop, value);
                    },
                  );
                } else {
                  return Text('Invalid prop handle type found');
                }
              });
        },
      ),
    );
  }
}

class GroupLabel extends StatelessWidget {
  const GroupLabel({
    Key key,
    @required this.group,
  }) : super(key: key);

  final PropGroup group;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              group.label,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Divider(),
          ],
        ),
      );
}

class EditablePropField extends StatelessWidget {
  const EditablePropField({
    Key key,
    @required this.maxWidth,
    @required this.prop,
    @required this.textChanged,
  }) : super(key: key);

  final BoxConstraints maxWidth;
  final PropHandle prop;
  final Function(PropHandle, String) textChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Container(
            constraints: maxWidth,
            child: TextField(
              keyboardType: prop is NumberPropHandle
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: prop.label,
              ),
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: prop.textValue,
                  selection: TextSelection.collapsed(
                      offset: prop.value.toString().length))),
              onChanged: (value) => textChanged(prop, value),
            ),
          ),
        ],
      );
}

class CheckablePropField extends StatelessWidget {
  final BooleanPropHandle prop;
  final Function(BooleanPropHandle, bool) checkboxChanged;
  final BoxConstraints maxWidth;

  const CheckablePropField(
      {Key key,
      @required this.prop,
      @required this.checkboxChanged,
      @required this.maxWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        constraints: maxWidth,
        child: Row(
          children: <Widget>[
            Text(prop.label),
            Checkbox(
                value: prop.value,
                onChanged: (value) => checkboxChanged(prop, value)),
          ],
        ),
      );
}

class RangePropField extends StatelessWidget {
  final RangePropHandle prop;
  final Function(RangePropHandle, double) rangeChanged;

  const RangePropField(
      {Key key, @required this.prop, @required this.rangeChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(prop.label),
        Slider(
          value: prop.value.currentValue,
          max: prop.value.max,
          min: prop.value.min,
          onChanged: (value) => rangeChanged(prop, value),
        ),
      ],
    );
  }
}

class ValueSelectorField<T> extends StatelessWidget {
  final PropValuesHandle<T> prop;
  final Function(PropValuesHandle<T>, T) valueChanged;

  const ValueSelectorField(
      {Key key, @required this.prop, @required this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(prop.label),
            DropdownButton(
              value: prop.value.selectedValue,
              onChanged: (value) => valueChanged(prop, value),
              items: [
                ...prop.value.values.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text("$e"),
                    )),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class RadioSelectorField<T> extends StatelessWidget {
  final RadioValuesHandle<T> prop;
  final Function(RadioValuesHandle<T>, T) valueChanged;

  const RadioSelectorField(
      {Key key, @required this.prop, @required this.valueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(prop.label),
            ...prop.value.values.map((e) => Container(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: RadioListTile(
                    title: Text(e.toString()),
                    groupValue: prop.value.selectedValue,
                    onChanged: (value) {
                      valueChanged(prop, value);
                    },
                    value: e,
                  ),
                )),
          ],
        ),
      ],
    );
  }
}

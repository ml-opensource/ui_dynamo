import 'package:example/widgets/inputs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_dynamo/ui_dynamo.dart';

DynamoPage buildInputsPage() => DynamoPage.list(
    title: 'Inputs',
    icon: Icon(Icons.input),
    children: (context) {
      final input = context.props.twoWay.text('Input', 'Primary Input');
      final errorInput = context.props.twoWay.text('Error Input', '');
      final counterInput =
          context.props.twoWay.text('Counter Input', 'Characters');
      return [
        Organization.container(
          title: Text('Basic Input'),
          children: [
            AppInput(
              label: 'Label',
              onChanged: context.actions
                  .valueChanged('Input', through: input.onChanged),
              value: input.value,
            ),
          ],
        ),
        Organization.container(title: Text('Error Input'), children: [
          AppInput(
            label: 'Label',
            onChanged: context.actions
                .valueChanged('Error Input', through: errorInput.onChanged),
            value: errorInput.value,
            errorText: 'This is an example error.',
          ),
        ]),
        Organization.container(title: Text('Counter Input'), children: [
          AppInput(
            label: 'Label',
            onChanged: context.actions
                .valueChanged('Counter Input', through: counterInput.onChanged),
            value: counterInput.value,
            maxCount: 40,
          )
        ]),
        PropTable(
          minCellWidth: 200,
          items: [
            PropTableItem(name: 'label', description: 'Give the input a label'),
            PropTableItem(
                name: 'onChanged', description: 'Called when input changes'),
            PropTableItem(
                name: 'value',
                description:
                    'Supply current value. This component is stateless'),
            PropTableItem(
                name: 'maxCount',
                description:
                    'The maximum count for the input. Will activate counter UI',
                defaultValue: 'null'),
            PropTableItem(
                name: 'errorText',
                description: 'Display an error if specified.',
                defaultValue: 'null',
                example: AppInput(
                  label: 'Error',
                  onChanged: (value) {},
                  value: 'abg@gm',
                  errorText: 'Invalid email',
                ))
          ],
        ),
      ];
    });

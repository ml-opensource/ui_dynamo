import 'package:example/widgets/inputs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildInputsPage() => StoryBookPage.list(
    title: 'Inputs',
    icon: Icon(Icons.input),
    widgets: (context) {
      final input = context.props.input('Input', 'Primary Input');
      final errorInput = context.props.input('Error Input', '');
      final counterInput = context.props.input('Counter Input', 'Characters');
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
        ])
      ];
    });

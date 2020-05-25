import 'package:example/widgets/inputs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildInputsPage() => StoryBookPage.list(
    title: 'Inputs',
    icon: Icon(Icons.input),
    widgets: (context) {
      final input = context.props.input('Input', 'Primary Input');
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
        )
      ];
    });

import 'package:example/widgets/radios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildRadiosPage() => StoryBookPage.list(
      title: "Radios",
      icon: Icon(Icons.radio_button_checked),
      widgets: (context) {
        final radio = context.props.radioProp(
            'Radios',
            PropValues(
              selectedValue: "Yellow",
              values: [
                "Yellow",
                "Red",
                "Green",
              ],
            ));
        return [
          Organization.container(
            title: Text("Plain Radios"),
            children: [
              RadioGroup(
                  valueChanged: context.actions
                      .valueChanged("Plain Radio", through: radio.onChanged),
                  selectedValue: radio.value),
            ],
          ),
        ];
      },
    );

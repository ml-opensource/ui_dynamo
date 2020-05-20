import 'package:example/widgets/radios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';

StoryBookPage buildRadiosPage() => StoryBookPage.list(
      title: "Radios",
      icon: Icon(Icons.radio_button_checked),
      widgets: (context) => [
        Organization.container(title: Text("Plain Radios"), children: [
          RadioGroup(
            valueChanged: (value) {
              context.actions.valueChanged("Plain Radio")(value);
              context.props.radioChanged("Radios", value);
            },
            selectedValue: context.props.radios(
                "Radios",
                PropValues(
                  selectedValue: "Yellow",
                  values: [
                    "Yellow",
                    "Red",
                    "Green",
                  ],
                )),
          ),
        ]),
      ],
    );

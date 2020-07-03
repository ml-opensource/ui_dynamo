import 'package:example/widgets/radios.dart';
import 'package:flutter/material.dart';
import 'package:ui_dynamo/ui_dynamo.dart';

DynamoPage buildRadiosPage() => DynamoPage.list(
      title: "Radios",
      icon: Icon(Icons.radio_button_checked),
      children: (context) {
        final radio = context.props.twoWay.radio(
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

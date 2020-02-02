import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Text mainTitle(String text) => Text(
      text,
      style: TextStyle(fontSize: 32),
    );

Text subTitle(String text) => Text(
      text,
      style: TextStyle(fontSize: 24),
    );

Text h3(String text) => Text(
      text,
      style: TextStyle(fontSize: 20),
    );

Text body(String text) => Text(
      text,
      style: TextStyle(fontSize: 20.0, color: Colors.grey),
    );

import 'package:flutter/material.dart';

double calculateLeft(Offset offset, Offset parentOffset, double scale) =>
    parentOffset.dx + (scale * offset.dx);

double calculateTop(Offset offset, Offset parentOffset, double scale) =>
    parentOffset.dy + (scale * offset.dy);

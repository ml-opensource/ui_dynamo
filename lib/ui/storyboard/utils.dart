import 'package:flutter/material.dart';

double calculateLeft(Offset offset, Offset parentOffset, double scale) =>
    parentOffset.dx + (offset.dx * scale);

double calculateTop(Offset offset, Offset parentOffset, double scale) {
  var d = parentOffset.dy + (offset.dy * scale);
  return d;
}

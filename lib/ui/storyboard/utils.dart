import 'package:flutter/material.dart';

double calculateLeft(Offset offset, Offset parentOffset, double scale) =>
    parentOffset.dx + (scale * offset.dx);

double calculateTop(Offset offset, Offset parentOffset, double scale) {
  var d = parentOffset.dy + (scale * offset.dy);
  return d < 0 ? 0 : d;
}

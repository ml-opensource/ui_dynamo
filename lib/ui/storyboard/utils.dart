import 'package:flutter/material.dart';

double calculateLeft(Offset offset, Offset parentOffset, double scale) {
  var d = parentOffset.dx + (scale * offset.dx);
  return d < 0 ? 0 : d;
}

double calculateTop(Offset offset, Offset parentOffset, double scale) {
  var d = parentOffset.dy + (scale * offset.dy);
  return d < 0 ? 0 : d;
}

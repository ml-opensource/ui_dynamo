import 'package:flutter/cupertino.dart';

const MOBILE_SIZE = 580;
const TABLET_SIZE = 800;
const DESKTOP_SIZE = 1140;

bool isWatch(BuildContext context) {
  final query = MediaQuery.of(context);
  return query.size.width < MOBILE_SIZE && query.size.height < MOBILE_SIZE;
}

bool isMobile(BuildContext context) {
  final query = MediaQuery.of(context);
  return query.size.width <= MOBILE_SIZE;
}

bool isTablet(BuildContext context, {bool inclusive = false}) {
  final query = MediaQuery.of(context);
  return query.size.width > MOBILE_SIZE &&
      (inclusive ? query.size.width <= TABLET_SIZE : true);
}

bool isDesktop(BuildContext context) {
  final query = MediaQuery.of(context);
  return query.size.width > TABLET_SIZE;
}

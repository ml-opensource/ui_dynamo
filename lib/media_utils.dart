import 'package:flutter/cupertino.dart';

const MOBILE_SIZE = 580;
const TABLET_SIZE = 800;
const DESKTOP_SIZE = 1140;

extension MediaUtils on BuildContext {
  bool get isWatch {
    final query = MediaQuery.of(this);
    return query.size.width < MOBILE_SIZE && query.size.height < MOBILE_SIZE;
  }

  bool get isMobile {
    final query = MediaQuery.of(this);
    return query.size.width <= MOBILE_SIZE;
  }

  bool get isTablet => isTabletInclusive(false);

  bool isTabletInclusive(bool inclusive) {
    final query = MediaQuery.of(this);
    return query.size.width > MOBILE_SIZE &&
        (inclusive ? query.size.width <= TABLET_SIZE : true);
  }

  bool get isDesktop {
    final query = MediaQuery.of(this);
    return query.size.width > TABLET_SIZE;
  }
}

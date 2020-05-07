import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

extension BoundedSize on Size {
  Size boundedSize(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = this.width == double.infinity ? media.size.width : this.width;
    final height =
        this.height == double.infinity ? media.size.height : this.height;
    return Size(width, height);
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Listens for both ScrollWheel and Pan gestures to make offset changes easy.
class PanScrollDetector extends StatelessWidget {
  final Widget child;
  final Function(Offset) onOffsetChange;

  const PanScrollDetector(
      {Key key, @required this.child, @required this.onOffsetChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerSignal: (event) {
        if (event is PointerScrollEvent &&
            event.kind == PointerDeviceKind.mouse) {
          /// scroll when user scrolls
          onOffsetChange(event.scrollDelta);
        }
      },
      child: GestureDetector(
        onPanUpdate: (panDetails) => onOffsetChange(panDetails.delta),
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );
  }
}

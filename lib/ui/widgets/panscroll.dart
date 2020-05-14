import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Listens for both ScrollWheel and Pan gestures to make offset changes easy.
class PanScrollDetector extends StatelessWidget {
  final Widget child;
  final Function(Offset) onOffsetChange;
  final bool isPanningEnabled;
  final bool isVerticalEnabled;
  final bool isHorizontalEnabled;

  const PanScrollDetector(
      {Key key,
      @required this.child,
      @required this.onOffsetChange,
      this.isPanningEnabled = true,
      this.isVerticalEnabled = false,
      this.isHorizontalEnabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerSignal: (event) {
        if (event is PointerScrollEvent &&
            event.kind == PointerDeviceKind.mouse) {
          /// scroll when user scrolls
          if ((event.scrollDelta.dx != 0 && isHorizontalEnabled) ||
              (event.scrollDelta.dy != 0 && isVerticalEnabled) ||
              isPanningEnabled) {
            onOffsetChange(event.scrollDelta);
          }
        }
      },
      child: GestureDetector(
        onVerticalDragUpdate: isVerticalEnabled
            ? (details) => onOffsetChange(details.delta)
            : null,
        onHorizontalDragUpdate: isHorizontalEnabled
            ? (details) => onOffsetChange(details.delta)
            : null,
        onPanUpdate: isPanningEnabled
            ? (panDetails) => onOffsetChange(panDetails.delta)
            : null,
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );
  }
}

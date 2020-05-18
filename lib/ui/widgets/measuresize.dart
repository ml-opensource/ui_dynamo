import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef void OnWidgetSizeChange(Size size);

class MeasureSizeProvider extends ChangeNotifier {
  static MeasureSizeProvider of(BuildContext context) =>
      Provider.of<MeasureSizeProvider>(context);

  void notifySizeChange() {
    notifyListeners();
  }
}

class MeasureSize extends StatefulWidget {
  final Widget child;
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key key,
    @required this.onChange,
    @required this.child,
  }) : super(key: key);

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MeasureSizeProvider(),
      child: Consumer<MeasureSizeProvider>(
        builder: (context, value, child) {
          SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
          return Container(
            key: widgetKey,
            child: widget.child,
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  var widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}

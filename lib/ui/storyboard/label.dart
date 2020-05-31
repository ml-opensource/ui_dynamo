import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/ui/drawer/drawer_provider.dart';

class StoryBookLabel extends StatelessWidget {
  final String label;
  final String routeName;
  final bool isFlowStart;

  const StoryBookLabel({Key key, this.label, this.routeName, this.isFlowStart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsetsDirectional.only(top: 10),
        padding: EdgeInsetsDirectional.only(
          start: 18.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            CurrentDeviceIcon(isFlowStart: isFlowStart, routeName: routeName)
          ],
        ),
      ),
    );
  }
}

class CurrentDeviceIcon extends StatelessWidget {
  const CurrentDeviceIcon({
    Key key,
    @required this.isFlowStart,
    @required this.routeName,
  }) : super(key: key);

  final bool isFlowStart;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final device = context.mediaQueryProvider.currentDevice;
    return IconButton(
      icon: Icon(!isFlowStart ? device.iconForCategory : Icons.arrow_forward),
      onPressed: () {
        drawer(context)
            .select(context, ValueKey('Routes'), ValueKey(routeName));
      },
    );
  }
}

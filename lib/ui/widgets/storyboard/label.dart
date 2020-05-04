import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/ui/drawer_provider.dart';

class StoryBookLabel extends StatelessWidget {
  final String label;
  final String routeName;

  const StoryBookLabel({Key key, this.label, this.routeName}) : super(key: key);

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
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: routeName != null,
              child: IconButton(
                icon: Icon(Icons.smartphone),
                onPressed: () {
                  drawer(context)
                      .select(context, ValueKey('Routes'), ValueKey(routeName));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

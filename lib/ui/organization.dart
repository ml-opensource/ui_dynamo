import 'package:flutter/material.dart';

/// A visual separator between widgets.
/// Places them in a visual container.
class ExpandableWidgetSection extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final String subtitle;
  final bool initiallyExpanded;

  const ExpandableWidgetSection(
      {Key key,
      @required this.title,
      @required this.children,
      this.subtitle,
      this.initiallyExpanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ExpansionTile(
                initiallyExpanded: initiallyExpanded,
                title: Text(
                  title,
                  style: TextStyle(fontSize: 26),
                ),
                subtitle: (subtitle != null)
                    ? Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(subtitle),
                      )
                    : null,
                children: [
                  Divider(
                    thickness: 2.0,
                    height: 32,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ...children,
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetContainer extends StatelessWidget {
  final List<Widget> children;
  final Widget title;
  final Color cardBackgroundColor;

  const WidgetContainer(
      {Key key,
      @required this.title,
      @required this.children,
      this.cardBackgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: 26,
              ),
              child: title,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

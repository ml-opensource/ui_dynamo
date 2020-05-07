import 'package:flutter/material.dart';
import 'package:flutter_storybook/ui/widgets/text.dart';

const double kMaxOrgSize = 1000.0;

class PresentationWidget extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const PresentationWidget(
      {Key key, this.maxWidth = kMaxOrgSize, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
            child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: child,
              ),
            ],
          ),
        ))
      ]);
}

/// A visual separator between widgets.
/// Places them in a visual container.
class ExpandableWidgetSection extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final String subtitle;
  final bool initiallyExpanded;
  final double maxWidth;

  const ExpandableWidgetSection(
      {Key key,
      @required this.title,
      @required this.children,
      this.subtitle,
      this.maxWidth = kMaxOrgSize,
      this.initiallyExpanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PresentationWidget(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Theme(
                  data: theme.copyWith(
                    dividerColor: theme.cardColor,
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: initiallyExpanded,
                    title: StyledText.header(Text(title)),
                    subtitle: (subtitle != null)
                        ? Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(subtitle),
                          )
                        : null,
                    children: [
                      Divider(
                        thickness: 1.0,
                        color: theme.dividerColor,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetContainer extends StatelessWidget {
  final List<Widget> children;
  final Widget title;
  final Color cardBackgroundColor;
  final EdgeInsets padding;
  final double childrenSpacing;

  const WidgetContainer({
    Key key,
    @required this.title,
    @required this.children,
    this.cardBackgroundColor,
    this.padding = const EdgeInsets.all(16.0),
    this.childrenSpacing = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PresentationWidget(
      child: Card(
        color: cardBackgroundColor,
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StyledText.header(title),
              SizedBox(
                height: 15,
              ),
              ListView.separated(
                  itemBuilder: (context, index) => Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: children[index]),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(
                        height: childrenSpacing,
                      ),
                  itemCount: children.length),
            ],
          ),
        ),
      ),
    );
  }
}

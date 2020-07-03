import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/ui/styles/text_styles.dart';

class HeaderTextWidget extends StatelessWidget {
  final Widget title;

  const HeaderTextWidget({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: headerStyle,
      child: title,
    );
  }
}

class StyledText extends StatelessWidget {
  final Widget text;
  final TextStyle textStyle;

  const StyledText({Key key, @required this.text, @required this.textStyle})
      : super(key: key);

  factory StyledText.header(Widget text) => StyledText(
        text: text,
        textStyle: headerStyle,
      );

  factory StyledText.body(Widget text) => StyledText(
        text: text,
        textStyle: bodyStyle,
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      child: text,
      style: textStyle,
    );
  }
}

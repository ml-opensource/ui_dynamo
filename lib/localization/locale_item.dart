import 'package:flutter/material.dart';

class LocaleItem extends StatelessWidget {
  final Locale selectedLocale;
  final GestureTapCallback onTap;

  const LocaleItem({Key key, @required this.selectedLocale, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language),
          SizedBox(
            width: 8.0,
          ),
          Text(selectedLocale.toString()),
        ],
      ),
    );
  }
}

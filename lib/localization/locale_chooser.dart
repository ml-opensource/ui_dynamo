import 'package:flutter/material.dart';
import 'package:ui_dynamo/localization/locale_item.dart';
import 'package:ui_dynamo/localization/localizations_plugin.dart';

const defaultLocales = [
  Locale('en'),
  Locale('es'),
];

class LocaleChooser extends StatelessWidget {
  const LocaleChooser({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedLocale = context.locales;
    return PopupMenuButton(
      tooltip: 'Choose current Locale',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LocaleItem(selectedLocale: selectedLocale.overrideLocale),
      ),
      onSelected: (l) => selectedLocale.localeChanged(l),
      itemBuilder: (context) => selectedLocale.supportedLocales
          .map((e) => CheckedPopupMenuItem(
                value: e,
                child: LocaleItem(
                  selectedLocale: e,
                ),
                checked: selectedLocale.overrideLocale == e,
              ))
          .toList(),
    );
  }
}

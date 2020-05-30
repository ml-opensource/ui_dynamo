import 'package:flutter/material.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';

const defaultLocales = [
  Locale('en'),
  Locale('es'),
];

class LocaleChooser extends StatelessWidget {
  final List<Locale> supportedLocales;

  const LocaleChooser({Key key, this.supportedLocales = defaultLocales})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.mediaQueryProvider;
    final selectedLocale = provider.overrideLocale;
    return PopupMenuButton(
      tooltip: 'Choose current Locale',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildLocaleItem(selectedLocale),
      ),
      onSelected: (l) => provider.localeChanged(l),
      itemBuilder: (context) => supportedLocales
          .map((e) => CheckedPopupMenuItem(
                value: e,
                child: buildLocaleItem(e),
                checked: selectedLocale == e,
              ))
          .toList(),
    );
  }

  Row buildLocaleItem(Locale selectedLocale) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language),
          SizedBox(
            width: 8.0,
          ),
          Text(buildLocaleText(selectedLocale)),
        ],
      );

  String buildLocaleText(Locale selectedLocale) => selectedLocale.toString();
}

import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/localization/localizations_plugin.dart';
import 'package:flutter_storybook/ui/toolbar.dart';

class LocalizationRow {
  final String key;
  final String value;

  LocalizationRow(this.key, this.value);
}

class LocalizationsHeader {
  final String name;

  LocalizationsHeader(this.name);
}

class LocationsDisplay extends StatelessWidget {
  final List<LocalizationsDelegate<dynamic>> localizationDisplay;

  const LocationsDisplay({Key key, this.localizationDisplay = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locales = context.locales;
    return StreamBuilder<List<dynamic>>(
        stream: Future.wait(
                localizationDisplay.map((e) => e.load(locales.overrideLocale)))
            .asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          }
          final data = snapshot.data;
          if (data.isEmpty) {
            return EmptyToolbarView(
              text: StyledText.body(
                Text('No LocalizationDelegates Found. You can can add them '
                    'to your app to see them here.'),
              ),
            );
          }
          final list = localizationsListForLocalizable(data);
          return ListView.builder(
            itemBuilder: (context, index) {
              var data = list[index];
              if (data is LocalizationsHeader) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: StyledText.header(Text(data.name)),
                );
              }
              if (data is LocalizationRow) {
                return ListTile(
                  title: Text(data.key),
                  subtitle: Text(data.value),
                );
              }
              return Text('Invalid');
            },
            itemCount: list.length,
          );
        });
  }

  List<dynamic> localizationsListForLocalizable(List data) {
    final List<dynamic> list = [];
    data.forEach((element) {
      if (element is Localizable) {
        list.add(LocalizationsHeader(element.name));
        list.addAll(element
            .localizations()
            .entries
            .map((e) => LocalizationRow(e.key, e.value)));
      }
    });
    return list;
  }
}

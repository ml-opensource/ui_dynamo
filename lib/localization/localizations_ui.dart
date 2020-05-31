import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/localization/localizations_plugin.dart';
import 'package:flutter_storybook/ui/toolbar.dart';

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
          if (snapshot.data.isEmpty) {
            return EmptyToolbarView(
              text: StyledText.body(
                Text('No LocalizationDelegates Found. You can can add them '
                    'to your app to see them here.'),
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) =>
                Text('$index ${snapshot.data[index]}'),
            itemCount: snapshot.data.length,
          );
        });
  }
}

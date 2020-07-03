import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:ui_dynamo/localization/localizations_ui.dart';
import 'package:ui_dynamo/plugins/plugin.dart';
import 'package:provider/provider.dart';

/// Implement this class to provide the set of localizations
/// for a map.
class Localizable {

  String get name => '';

  Map<String, String> localizations() => {};
}

class LocalizationsPlugin extends ChangeNotifier {
  final List<Locale> supportedLocales;

  /// overrides app-level locales.
  Locale _overrideLocale;

  LocalizationsPlugin(this.supportedLocales, this._overrideLocale);

  /// Retrieves [LocalizationsPlugin] from the [BuildContext]
  factory LocalizationsPlugin.of(BuildContext context) =>
      Provider.of<LocalizationsPlugin>(context);

  void localeChanged(Locale locale) {
    this._overrideLocale = locale;
    notifyListeners();
  }

  Locale get overrideLocale => _overrideLocale;
}

extension LocalizationsPluginExtension on BuildContext {
  LocalizationsPlugin get locales => LocalizationsPlugin.of(this);
}

DynamoPlugin localizationsPlugin(
        {List<Locale> supportedLocales = const [],
        List<LocalizationsDelegate<dynamic>> localizationDisplay = const []}) =>
    DynamoPlugin<LocalizationsPlugin>(
      tabPane: (context) => LocationsDisplay(
        localizationDisplay: localizationDisplay,
      ),
      tabText: 'Localizations',
      provider: ChangeNotifierProvider(
        create: (context) =>
            LocalizationsPlugin(supportedLocales, supportedLocales[0]),
      ),
    );

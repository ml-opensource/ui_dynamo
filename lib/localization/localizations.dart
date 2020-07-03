import 'package:flutter/material.dart';
import 'package:ui_dynamo/localization/locale_chooser.dart';
import 'package:ui_dynamo/localization/localizations_file.dart';
import 'package:ui_dynamo/localization/localizations_plugin.dart';

class DynamoLocalizations implements Localizable {
  final Locale locale;

  DynamoLocalizations(this.locale);

  static DynamoLocalizationsDelegate get delegate =>
      DynamoLocalizationsDelegate();

  factory DynamoLocalizations.of(BuildContext context) =>
      Localizations.of(context, DynamoLocalizations);

  String localizedValue(String key) =>
      localizedValues[locale.languageCode][key] ??
      localizedValues[defaultLocales[0].languageCode][key];

  String get homeTitle {
    return localizedValue('homeTitle');
  }

  String get description1 {
    return localizedValue('description1');
  }

  String get description2 {
    return localizedValue('description2');
  }

  String get description3 {
    return localizedValue('description3');
  }

  String get description4 {
    return localizedValue('description4');
  }

  @override
  Map<String, String> localizations() => localizedValues[locale.languageCode];

  @override
  String get name => 'Dynamo Localizations';
}

extension LocalizedParam on String {
  /// Replaces parameters in a specified map.
  String params(Map<String, String> paramMap) {
    String retValue = this;
    paramMap.forEach((key, value) {
      retValue = retValue.replaceFirst("{{$key}}", value);
    });
    return retValue;
  }

  /// Replaces any specified [Widget] in the map and makes a [TextSpan] of the
  /// remaining values.
  /// Accepts [String] or [Widget] parameters
  Iterable<InlineSpan> toWidgetSpan(Map<String, dynamic> paramMap) {
    /// replace all non-string arguments.
    final Map<String, dynamic> map = Map.of(paramMap)
      ..removeWhere((key, value) => value is Widget);
    final Map<String, String> newMap = map.cast<String, String>();
    final mapWidgets = Map.of(paramMap)
      ..removeWhere((key, value) => !(value is Widget));
    String newValues = this.params(newMap);
    final split = newValues.split("{{");
    final List<InlineSpan> spans = [];
    split.forEach((e) {
      var modifiedE = e;
      if (e.contains("}}")) {
        modifiedE = "{{$e";
      }
      final index = modifiedE.indexOf(RegExp(r"{{(\w+)}}"));
      if (index >= 0) {
        mapWidgets.forEach((key, value) {
          if (modifiedE.contains("{{$key}}")) {
            modifiedE = modifiedE.replaceFirst("{{$key}}", "");
            spans.add(WidgetSpan(child: value));
          }
        });
      }
      spans.add(TextSpan(text: modifiedE));
    });
    return spans;
  }
}

class DynamoLocalizationsDelegate
    extends LocalizationsDelegate<DynamoLocalizations> {
  const DynamoLocalizationsDelegate();

  @override
  bool shouldReload(LocalizationsDelegate<DynamoLocalizations> old) => false;

  @override
  Future<DynamoLocalizations> load(Locale locale) async {
    return DynamoLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) => defaultLocales
      .any((element) => element.languageCode == locale.languageCode);
}

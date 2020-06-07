import 'package:flutter/material.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/localization/locale_item.dart';
import 'package:flutter_storybook/localization/localizations_plugin.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:flutter_storybook/ui/utils/collection+extensions.dart';
import 'package:rxdart/rxdart.dart';

class LocalizationRow {
  final String key;
  final String value;

  LocalizationRow(this.key, this.value);
}

class LocalizationsHeader {
  final String name;

  LocalizationsHeader(this.name);
}

class LocationsDisplay extends StatefulWidget {
  final List<LocalizationsDelegate<dynamic>> localizationDisplay;

  // ignore: close_sinks

  LocationsDisplay({Key key, this.localizationDisplay = const []})
      : super(key: key);

  @override
  _LocationsDisplayState createState() => _LocationsDisplayState();
}

class _LocationsDisplayState extends State<LocationsDisplay> {
  List<GlobalKey<_LocalizationPaneState>> keys;

  @override
  Widget build(BuildContext context) {
    final locales = context.locales;
    if (keys == null) {
      keys = locales.supportedLocales
          .map((e) =>
              GlobalKey<_LocalizationPaneState>(debugLabel: e.toString()))
          .toList();
    }
    return DefaultTabController(
      length: locales.supportedLocales.length,
      child: Container(
        child: Scaffold(
          appBar: TabBar(
            isScrollable: true,
            tabs: locales.supportedLocales
                .map((e) => Tab(
                      child: LocaleItem(
                        selectedLocale: e,
                      ),
                    ))
                .toList(),
            onTap: (index) {
              keys[index].currentState?.loadLocalizations();
            },
          ),
          body: TabBarView(
            children: locales.supportedLocales
                .mapIndexed(
                  (index, locale) => LocalizationPane(
                    key: keys[index],
                    localizationDisplay: widget.localizationDisplay,
                    locale: locale,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class LocalizationPane extends StatefulWidget {
  final List<LocalizationsDelegate<dynamic>> localizationDisplay;
  final Locale locale;

  // ignore: close_sinks

  LocalizationPane(
      {Key key, @required this.localizationDisplay, @required this.locale})
      : super(key: key);

  @override
  _LocalizationPaneState createState() => _LocalizationPaneState();
}

class _LocalizationPaneState extends State<LocalizationPane> {
  final BehaviorSubject<List<dynamic>> localizationsSubject =
      BehaviorSubject.seeded([]);

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

  void loadLocalizations() {
    Future.wait(widget.localizationDisplay.map((e) => e.load(widget.locale)))
        .asStream()
        .listen((event) {
      localizationsSubject.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (localizationsSubject.value.isEmpty) {
      loadLocalizations();
    }
    return StreamBuilder<List<dynamic>>(
        stream: localizationsSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading');
          }
          final data = snapshot.data;
          if (data.isEmpty) {
            return EmptyToolbarView(
              text: StyledText.body(
                Text(
                    'No LocalizationDelegates Found. Add localizationDelegates '
                    'to your MaterialApp and implement Localizable to see '
                    'all localizations here.'),
              ),
            );
          }
          final list = localizationsListForLocalizable(data);
          return ListView.builder(
            shrinkWrap: true,
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
}

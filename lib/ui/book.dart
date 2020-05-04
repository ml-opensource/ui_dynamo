import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/mediaquery.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:flutter_storybook/ui/drawer.dart';
import 'package:flutter_storybook/ui/drawer_provider.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:flutter_storybook/ui/widgets/page.dart';
import 'package:flutter_storybook/ui/widgets/storyboard/storyboard.dart';
import 'package:provider/provider.dart';

class StoryBook extends StatefulWidget {
  final StoryBookData data;
  final MaterialApp app;

  factory StoryBook.withApp(MaterialApp app,
          {@required StoryBookData data,
          Map<String, List<String>> routesMapping}) =>
      StoryBook(
        app: app,
        data: data.merge(items: [
          storyboard(app, title: 'Storyboard', routesMapping: routesMapping),
          StoryBookFolder.of(
            title: 'Routes',
            pages: [
              ...app.routes.entries.map((entry) =>
                  StoryBookPage.of(title: entry.key, child: entry.value)),
            ],
          ),
        ]),
      );

  const StoryBook({Key key, @required this.data, @required this.app})
      : super(key: key);

  @override
  _StoryBookState createState() => _StoryBookState();
}

class _StoryBookState extends State<StoryBook> {
  bool isDrawerOpen = false;

  StoryBookPage selectedPageFromWidget(BuildContext context) {
    final selectedFolderKey = drawer(context).folderKey;
    final selectedPageKey = drawer(context).pageKey;
    if (selectedFolderKey != null && selectedPageKey != null) {
      final folder = widget.data.items.firstWhere(
          (element) => element.key == selectedFolderKey,
          orElse: () => null);
      if (folder != null) {
        return folder.pageFromKey(selectedPageKey);
      }
    }
    return null;
  }

  void _selectPage(
      StoryBookPage page, StoryBookItem folder, BuildContext context) {
    drawer(context).select(context, folder.key, page.key, popDrawer: true);
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    return MaterialApp(
      theme: app.theme,
      darkTheme: app.darkTheme,
      debugShowCheckedModeBanner: app.debugShowCheckedModeBanner,
      themeMode: app.themeMode,
      locale: app.locale,
      localeListResolutionCallback: app.localeListResolutionCallback,
      localeResolutionCallback: app.localeResolutionCallback,
      localizationsDelegates: app.localizationsDelegates,
      supportedLocales: app.supportedLocales,
      debugShowMaterialGrid: app.debugShowMaterialGrid,
      showPerformanceOverlay: app.showPerformanceOverlay,
      showSemanticsDebugger: app.showSemanticsDebugger,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => ActionsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PropsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => DrawerProvider(),
          ),
        ],
        child: Builder(
          builder: (context) {
            final selectedPage = selectedPageFromWidget(context);
            return Scaffold(
              appBar: AppBar(
                title: selectedPage != null ? selectedPage.title : Text('Home'),
              ),
              drawer: Builder(
                builder: (context) => StoryBookDrawer(
                  data: widget.data,
                  selectedPage: selectedPage,
                  onSelectPage: (folder, page) =>
                      _selectPage(page, folder, context),
                ),
              ),
              resizeToAvoidBottomPadding: true,
              bottomNavigationBar:
                  selectedPage?.usesToolbar == true ? ToolbarPane() : null,
              body: (selectedPage != null)
                  ? StoryBookPageWrapperWidget(
                      selectedPage: selectedPage,
                      base: widget.app,
                    )
                  : _StoryBookHomePage(
                      base: widget.app,
                    ),
            );
          },
        ),
      ),
    );
  }
}

class StoryBookPageWrapperWidget extends StatelessWidget {
  const StoryBookPageWrapperWidget({
    Key key,
    @required this.selectedPage,
    @required this.base,
  }) : super(key: key);

  final StoryBookPage selectedPage;
  final MaterialApp base;

  @override
  Widget build(BuildContext context) {
    return MediaQueryChooser(
      base: base,
      shouldScroll: selectedPage.shouldScroll,
      builder: (context, data) => selectedPage.build(context, data),
    );
  }
}

class _StoryBookHomePage extends StatelessWidget {
  final MaterialApp base;

  const _StoryBookHomePage({
    Key key,
    @required this.base,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQueryChooser.mediaQuery(
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.book,
                size: 100,
                color: Colors.deepPurple,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Welcome to Flutter Storybook. ',
                style: TextStyle(fontSize: 30),
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: 'Click on a '),
                  WidgetSpan(child: Icon(Icons.folder)),
                  TextSpan(text: ' to select a page to preview.')
                ]),
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

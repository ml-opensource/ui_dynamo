import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_extensions.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/media_query_toolbar.dart';
import 'package:flutter_storybook/mediaquery/mediaquery.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/props/props_extensions.dart';
import 'package:flutter_storybook/ui/drawer.dart';
import 'package:flutter_storybook/ui/drawer_provider.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/model/page.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:provider/provider.dart';

class StoryBook extends StatefulWidget {
  final StoryBookData data;
  final MaterialApp app;

  /// an extra set of Provider to inject into the storybook hierarchy.
  final List<Provider> extraProviders;

  /// Constructs a new StoryBook with
  /// 1. default storyboard with all app routes. If routesMapping specified,
  /// use that.
  /// 2. A folder with all top-level page routes as a page.
  /// 3. Also, a default Home page using the default Storybook home page. If home
  /// is specified, render that widget instead.
  factory StoryBook.withApp(
    MaterialApp app, {
    Widget home,
    @required StoryBookData data,

    /// Specify a set of Flows to display within the default storybook
    /// instead of every application route. Each key is the name of the Flow
    /// and each value is the ordered list of screens shown.
    Map<String, List<String>> flowRoutesMapping = const {},

    /// Preview Routes are useful to add preview-able content to a route that
    /// typically does not exist in the normal application
    Map<String, WidgetBuilder> previewRoutes = const {},

    /// set to true to allow preview routes to override existing routes defined
    /// in the main application.
    bool allowPreviewRouteOverrides = false,
    List<Provider> extraProviders = const [],
  }) {
    final routes = app.routes ?? <String, WidgetBuilder>{};
    previewRoutes.forEach((key, value) {
      assert(() {
        if (routes.containsKey(key)) {
          throw FlutterError("Duplicate route $key found in application. "
              "Overridding an existing route will replace the functionality "
              "in StoryBook. If this was intentional, set allowPreviewRouteOverrides "
              "to true.");
        }
        return true;
      }());
      routes[key] = value;
    });
    final copiedApp = app.copyWith(
      routes: routes,
    );
    final updatedData = data.merge(items: [
      StoryBookPage.storyboard(copiedApp,
          title: 'Storyboard', routesMapping: flowRoutesMapping),
      StoryBookFolder.of(
        title: 'Routes',
        pages: [
          ...app.routes.entries.map((entry) =>
              StoryBookPage.of(title: entry.key, child: entry.value)),
        ],
      ),
    ]);
    return StoryBook(
      app: copiedApp,
      extraProviders: extraProviders,
      data: updatedData.merge(items: [
        // merge with the folder routes so the home page can capture the data.
        StoryBookPage.of(
            title: 'Home',
            icon: Icon(Icons.home),
            child: (context) =>
                home ??
                _StoryBookHomePage(
                  data: updatedData,
                )),
      ], mergeFirst: true),
    );
  }

  const StoryBook(
      {Key key,
      @required this.data,
      @required this.app,
      this.extraProviders = const []})
      : super(key: key);

  @override
  _StoryBookState createState() => _StoryBookState();
}

class _StoryBookState extends State<StoryBook> {
  bool isDrawerOpen = false;

  void _selectPage(
      StoryBookPage page, StoryBookItem folder, BuildContext context) {
    drawer(context).select(context, folder.key, page.key, popDrawer: true);
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    return MaterialApp(
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
          ChangeNotifierProvider(
            create: (context) => OverrideMediaQueryProvider(
                widget.data.defaultDevice ?? deviceSizes[0]),
          ),
          ...widget.extraProviders,
        ],
        child: Builder(
          builder: (context) {
            final selectedPage = selectedPageFromWidget(widget.data, context);
            final query = mediaQuery(context);
            return MaterialApp(
              theme: app.theme,
              darkTheme: app.darkTheme,
              debugShowCheckedModeBanner: app.debugShowCheckedModeBanner,
              themeMode:
                  query.currentMediaQuery.platformBrightness == Brightness.light
                      ? ThemeMode.light
                      : ThemeMode.dark,
              locale: app.locale,
              localeListResolutionCallback: app.localeListResolutionCallback,
              localeResolutionCallback: app.localeResolutionCallback,
              localizationsDelegates: app.localizationsDelegates,
              supportedLocales: app.supportedLocales,
              debugShowMaterialGrid: app.debugShowMaterialGrid,
              showPerformanceOverlay: app.showPerformanceOverlay,
              showSemanticsDebugger: app.showSemanticsDebugger,
              home: Scaffold(
                  appBar: AppBar(
                    title: selectedPage != null
                        ? selectedPage.title
                        : Text('Home'),
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
                  body: StoryBookPageWrapperWidget(
                    selectedPage: selectedPage,
                    base: widget.app,
                  )),
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
  final StoryBookData data;

  const _StoryBookHomePage({
    Key key,
    @required this.data,
  }) : super(key: key);

  void _selectPage(
      StoryBookPage page, StoryBookItem folder, BuildContext context) {
    drawer(context).select(context, folder.key, page.key, popDrawer: true);
  }

  buildRoutesListing(StoryBookPage selectedPage, BuildContext context,
          StoryBookData data) =>
      Row(
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Card(
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: RoutesList(
                  shrinkWrap: true,
                  data: data,
                  selectedPage: selectedPage,
                  onSelectPage: (folder, page) =>
                      _selectPage(page, folder, context),
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final selectedPage = selectedPageFromWidget(data, context);
    return Container(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
      alignment: AlignmentDirectional.center,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 32,
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              Icon(
                Icons.book,
                size: 50,
              ),
              Text(
                'Welcome to Flutter Storybook. ',
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: 'Start with the storyboard '),
              WidgetSpan(child: Icon(Icons.book)),
              TextSpan(text: ' to view your whole app on one screen.')
            ]),
            style: TextStyle(fontSize: 20),
          ),
          buildRoutesListing(selectedPage, context,
              data.copyWith(items: data.items.sublist(0, 1))),
          SizedBox(
            height: 16,
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: ' Select a '),
              WidgetSpan(child: Icon(Icons.folder)),
              TextSpan(text: ' to pick a page to preview.'),
              TextSpan(text: ' The drawer '),
              WidgetSpan(child: Icon(Icons.menu)),
              TextSpan(text: ' also contains the same.')
            ]),
            style: TextStyle(fontSize: 20),
          ),
          buildRoutesListing(selectedPage, context,
              data.copyWith(items: data.items.sublist(1))),
          SizedBox(
            height: 16,
          ),
          Text(
            '3. Utilize the toolbar at the top to change MediaQueryData passed '
            'down to the rendered screens. Each page in the storybook / storyboard is a '
            'separate app experience.',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Flexible(
                child: MediaQueryToolbar(),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            '4. Utilize Props to preview test data and experiment with '
            'how widgets get rendered. Utilize actions to quickly debug action '
            'streams.',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

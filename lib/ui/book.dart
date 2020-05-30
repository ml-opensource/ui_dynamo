import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/actions/actions_plugin.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/localization/localizations_plugin.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/mediaquery/device_size_plugin.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';
import 'package:flutter_storybook/mediaquery/override_media_query_provider.dart';
import 'package:flutter_storybook/models.dart';
import 'package:flutter_storybook/plugins/plugin.dart';
import 'package:flutter_storybook/props/props_plugin.dart';
import 'package:flutter_storybook/ui/drawer/drawer.dart';
import 'package:flutter_storybook/ui/drawer/drawer_provider.dart';
import 'package:flutter_storybook/ui/home_page.dart';
import 'package:flutter_storybook/ui/materialapp+extensions.dart';
import 'package:flutter_storybook/ui/model/page.dart';
import 'package:flutter_storybook/ui/page_wrapper.dart';
import 'package:flutter_storybook/ui/toolbar.dart';
import 'package:provider/provider.dart';

class StoryBook extends StatefulWidget {
  final StoryBookData data;
  final MaterialApp app;

  /// an extra set of Provider to inject into the storybook hierarchy.
  final List<StoryBookPlugin> plugins;

  /// Constructs a new StoryBook with
  /// 1. default storyboard with all app routes. If routesMapping specified,
  /// use that.
  /// 2. A folder with all top-level page routes as a page.
  /// 3. Also, a default Home page using the default Storybook home page. If home
  /// is specified, render that widget instead.
  factory StoryBook.withApp(MaterialApp app,
      {

      /// use this to replace the default home widget.
      Widget home,

      /// If true, all provided static routes from the provided [app]
      /// are added as pages in a directory called "Routes".
      bool createRoutePages = true,

      /// If true, a default "Storyboard" containing all of the app's routes
      /// (including preview routes) get added to one board. This can grow
      /// large if the app has many screens. You can set this to false, and
      /// alternatively create a custom [StoryBookPage.storyboard] instead with
      /// a provided [StoryBoard.routesMapping].
      bool createAppStoryBoard = true,

      /// The data to render each page and define how storybook operates.
      @required StoryBookData data,

      /// Preview Routes are useful to add preview-able content to a route that
      /// typically does not exist in the normal application
      Map<String, WidgetBuilder> previewRoutes = const {},

      /// set to true to allow preview routes to override existing routes defined
      /// in the main application.
      bool allowPreviewRouteOverrides = false,

      /// Define extra plugins for this app to use in inherited widgets.
      List<StoryBookPlugin> plugins = const [],

      /// if true, props and actions are provided. if false, it requires using
      /// [plugins] manually
      bool useDefaultPlugins = true,

      /// If specified, adds extra devices to the [DeviceSizesPlugin]
      Iterable<DeviceInfo> extraDevices = const [],

      /// If false, whatever you specify in [extraDevices] will get used
      /// as the device sizes dropdown.
      bool useDeviceSizeDefaults = true}) {
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
    final updatedData =
        data.merge(title: data.title ?? Text(app.title), items: [
      if (createAppStoryBoard)
        StoryBookPage.storyboard(appOverride: copiedApp, title: 'Storyboard'),
      if (createRoutePages)
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
      plugins: [
        ...plugins,
        deviceSizesPlugin(
            extraDevices: extraDevices, useDefaults: useDeviceSizeDefaults),
        localizationsPlugin(
            supportedLocales: app.supportedLocales,
            localizationDisplay: app.localizationsDelegates),
        if (useDefaultPlugins) ...[
          propsPlugin(),
          actionsPlugin(),
        ],
      ],
      data: updatedData.merge(items: [
        // merge with the folder routes so the home page can capture the data.
        StoryBookPage.of(
            title: 'Home',
            icon: Icon(Icons.home),
            child: (context) =>
                home ??
                StoryBookHomePage(
                  data: updatedData,
                )),
      ], mergeFirst: true),
    );
  }

  const StoryBook(
      {Key key,
      @required this.data,
      @required this.app,
      this.plugins = const []})
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
            create: (context) => DrawerProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => OverrideMediaQueryProvider(
              widget.data.defaultDevice ?? deviceSizes[0],
            ),
          ),
          ...widget.plugins.map(
            (e) => e.provider,
          ),
        ],
        child: Builder(
          builder: (context) {
            final selectedPage = selectedPageFromWidget(widget.data, context);
            final query = context.mediaQueryProvider;
            final desktop = context.isDesktop;
            final toolbarPane = selectedPage?.usesToolbar == true
                ? ToolbarPane(
                    onBottom: !desktop,
                    plugins: widget.plugins
                        .where((element) => element.tabText != null)
                        .toList(),
                  )
                : null;
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
                  title:
                      selectedPage != null ? selectedPage.title : Text('Home'),
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
                bottomNavigationBar: desktop ? null : toolbarPane,
                body: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: StoryBookPageWrapper(
                        base: app,
                        shouldScroll: selectedPage.shouldScroll,
                        builder: selectedPage.widget.builder,
                      ),
                    ),
                    if (desktop && toolbarPane != null) toolbarPane,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

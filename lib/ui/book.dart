import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ui_dynamo/actions/actions_plugin.dart';
import 'package:ui_dynamo/ui_dynamo.dart';
import 'package:ui_dynamo/localization/localizations_plugin.dart';
import 'package:ui_dynamo/media_utils.dart';
import 'package:ui_dynamo/mediaquery/device_size_plugin.dart';
import 'package:ui_dynamo/mediaquery/device_sizes.dart';
import 'package:ui_dynamo/mediaquery/offset_plugin.dart';
import 'package:ui_dynamo/mediaquery/override_media_query_plugin.dart';
import 'package:ui_dynamo/models.dart';
import 'package:ui_dynamo/plugins/plugin.dart';
import 'package:ui_dynamo/props/props_plugin.dart';
import 'package:ui_dynamo/ui/drawer/drawer.dart';
import 'package:ui_dynamo/ui/drawer/drawer_provider.dart';
import 'package:ui_dynamo/ui/home_page.dart';
import 'package:ui_dynamo/ui/materialapp+extensions.dart';
import 'package:ui_dynamo/ui/model/page.dart';
import 'package:ui_dynamo/ui/page_wrapper.dart';
import 'package:ui_dynamo/ui/toolbar.dart';
import 'package:provider/provider.dart';

class Dynamo extends StatefulWidget {
  final DynamoData data;
  final MaterialApp app;

  /// an extra set of Provider to inject into the dynamo hierarchy.
  final List<DynamoPlugin> plugins;

  /// Constructs a new Dynamo with
  /// 1. default storyboard with all app routes. If routesMapping specified,
  /// use that.
  /// 2. A folder with all top-level page routes as a page.
  /// 3. Also, a default Home page using the default Dynamo home page. If home
  /// is specified, render that widget instead.
  factory Dynamo.withApp(MaterialApp app,
      {

      /// use this to replace the default home widget.
      Widget home,

      /// If true, all provided static routes from the provided [app]
      /// are added as pages in a directory called "Routes".
      bool createRoutePages = true,

      /// If true, a default "Storyboard" containing all of the app's routes
      /// (including preview routes) get added to one board. This can grow
      /// large if the app has many screens. You can set this to false, and
      /// alternatively create a custom [DynamoPage.storyboard] instead with
      /// a provided [StoryBoard.routesMapping].
      bool createAppStoryBoard = true,

      /// The data to render each page and define how UIDynamo operates.
      @required DynamoData data,

      /// Preview Routes are useful to add preview-able content to a route that
      /// typically does not exist in the normal application
      Map<String, WidgetBuilder> previewRoutes = const {},

      /// set to true to allow preview routes to override existing routes defined
      /// in the main application.
      bool allowPreviewRouteOverrides = false,

      /// Define extra plugins for this app to use in inherited widgets.
      List<DynamoPlugin> plugins = const [],

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
              "in UIDynamo. If this was intentional, set allowPreviewRouteOverrides "
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
        DynamoPage.storyboard(appOverride: copiedApp, title: 'Storyboard'),
      if (createRoutePages)
        DynamoFolder.of(
          title: 'Routes',
          pages: [
            ...app.routes.entries.map((entry) =>
                DynamoPage.of(title: entry.key, child: entry.value)),
          ],
        ),
    ]);
    return Dynamo(
      app: copiedApp,
      plugins: [
        ...plugins,
        deviceSizesPlugin(
            extraDevices: extraDevices, useDefaults: useDeviceSizeDefaults),
        localizationsPlugin(
            supportedLocales: app.supportedLocales,
            localizationDisplay: app.localizationsDelegates ?? []),
        overrideMediaQueryPlugin(defaultDevice: data.defaultDevice),
        offsetPlugin(),
        if (useDefaultPlugins) ...[
          propsPlugin(),
          actionsPlugin(),
        ],
      ],
      data: updatedData.merge(items: [
        // merge with the folder routes so the home page can capture the data.
        DynamoPage.of(
            title: 'Home',
            icon: Icon(Icons.home),
            child: (context) =>
                home ??
                DynamoHomePage(
                  data: updatedData,
                )),
      ], mergeFirst: true),
    );
  }

  const Dynamo(
      {Key key,
      @required this.data,
      @required this.app,
      this.plugins = const []})
      : super(key: key);

  @override
  _DynamoState createState() => _DynamoState();
}

class _DynamoState extends State<Dynamo> {
  bool isDrawerOpen = false;

  void _selectPage(
      DynamoPage page, DynamoItem folder, BuildContext context) {
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
                  builder: (context) => DynamoDrawer(
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
                      child: DynamoPageWrapper(
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

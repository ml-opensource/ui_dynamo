import 'package:flutter/material.dart';

extension MaterialAppCopy on MaterialApp {
  MaterialApp isolatedCopy(
          {@required Widget home,
          @required MediaQueryData data,
          @required Locale overrideLocale}) =>
      MaterialApp(
        // don't need checked banner, its part of top-level app.
        debugShowCheckedModeBanner: false,
        routes: routes,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        theme: theme,
        darkTheme: darkTheme,
        locale: overrideLocale ?? locale,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        themeMode: data.platformBrightness == Brightness.light
            ? ThemeMode.light
            : ThemeMode.dark,
        home: Material(child: home),
      );

  MaterialApp copyWith({
    GlobalKey<NavigatorState> navigatorKey,
    Widget home,
    Map<String, WidgetBuilder> routes = const <String, WidgetBuilder>{},
    String initialRoute,
    RouteFactory onGenerateRoute,
    InitialRouteListFactory onGenerateInitialRoutes,
    RouteFactory onUnknownRoute,
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
    TransitionBuilder builder,
    String title = '',
    GenerateAppTitle onGenerateTitle,
    Color color,
    ThemeData theme,
    ThemeData darkTheme,
    ThemeMode themeMode = ThemeMode.system,
    Locale locale,
    Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
    LocaleListResolutionCallback localeListResolutionCallback,
    LocaleResolutionCallback localeResolutionCallback,
    Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
    bool debugShowMaterialGrid = false,
    bool showPerformanceOverlay = false,
    bool checkerboardRasterCacheImages = false,
    bool checkerboardOffscreenLayers = false,
    bool showSemanticsDebugger = false,
    bool debugShowCheckedModeBanner = true,
    bool shortcuts,
    Map<Type, Action<Intent>> actions,
  }) =>
      MaterialApp(
        key: key,
        navigatorKey: navigatorKey ?? this.navigatorKey,
        home: home ?? this.home,
        routes: routes ?? this.routes,
        initialRoute: initialRoute ?? this.initialRoute,
        onGenerateRoute: onGenerateRoute ?? this.onGenerateRoute,
        onGenerateInitialRoutes:
            onGenerateInitialRoutes ?? this.onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute ?? this.onUnknownRoute,
        navigatorObservers: navigatorObservers ?? this.navigatorObservers,
        builder: builder ?? this.builder,
        title: title ?? this.title,
        onGenerateTitle: onGenerateTitle ?? this.onGenerateTitle,
        color: color ?? this.color,
        theme: theme ?? this.theme,
        darkTheme: darkTheme ?? this.darkTheme,
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
        localizationsDelegates:
            localizationsDelegates ?? this.localizationsDelegates,
        localeListResolutionCallback:
            localeListResolutionCallback ?? this.localeListResolutionCallback,
        localeResolutionCallback:
            localeListResolutionCallback ?? this.localeResolutionCallback,
        supportedLocales: supportedLocales ?? this.supportedLocales,
        debugShowMaterialGrid:
            debugShowMaterialGrid ?? this.debugShowMaterialGrid,
        showPerformanceOverlay:
            showPerformanceOverlay ?? this.showPerformanceOverlay,
        checkerboardRasterCacheImages:
            checkerboardRasterCacheImages ?? this.checkerboardRasterCacheImages,
        checkerboardOffscreenLayers:
            checkerboardOffscreenLayers ?? this.checkerboardOffscreenLayers,
        showSemanticsDebugger:
            showSemanticsDebugger ?? this.showSemanticsDebugger,
        debugShowCheckedModeBanner:
            debugShowCheckedModeBanner ?? this.debugShowCheckedModeBanner,
        shortcuts: shortcuts ?? this.shortcuts,
        actions: actions ?? this.actions,
      );
}

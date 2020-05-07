import 'package:flutter/material.dart';

extension MaterialAppCopy on MaterialApp {
  MaterialApp isolatedCopy({@required Widget home,
        @required MediaQueryData data}) =>
      MaterialApp(
        // don't need checked banner, its part of top-level app.
        debugShowCheckedModeBanner: false,
        routes: routes,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        theme: theme,
        darkTheme: darkTheme,
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
}

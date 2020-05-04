import 'package:flutter/material.dart';

extension MaterialAppCopy on MaterialApp {
  MaterialApp isolatedCopy({@required Widget home}) => MaterialApp(
        // don't need checked banner, its part of top-level app.
        debugShowCheckedModeBanner: false,
        routes: routes,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        themeMode: themeMode,
        theme: theme,
        darkTheme: darkTheme,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        home: Material(child: home),
      );
}

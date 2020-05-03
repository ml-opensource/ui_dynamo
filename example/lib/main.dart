import 'package:example/pages/main_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

MaterialApp buildApp() => MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        buttonColor: Colors.red,
        disabledColor: Colors.redAccent,
        iconTheme: IconThemeData(
          color: Colors.redAccent,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      routes: {
        '/home': (context) => MainPage(),
      },
      home: MainPage(),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return buildApp();
  }
}

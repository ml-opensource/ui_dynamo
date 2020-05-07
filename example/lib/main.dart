import 'package:example/pages/company_listing.dart';
import 'package:example/pages/main_page.dart';
import 'package:example/pages/person_detail.dart';
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
        backgroundColor: Colors.white,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.red,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.black26,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
          disabledColor: Colors.purpleAccent,
        ),
        iconTheme: IconThemeData(
          color: Colors.deepPurpleAccent,
        ),
        disabledColor: Colors.purpleAccent,
      ),
      routes: {
        '/home': (context) => MainPage(),
        '/company': (context) => CompanyListing(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final PersonDetailArguments args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => PersonDetail(
              item: args.item,
            ),
          );
        }
        return null;
      },
      initialRoute: "/home",
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

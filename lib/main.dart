//Design Library
//import 'dart:html';

import 'package:ba_locale/controller/splash.dart';
import 'package:ba_locale/model/style.dart';
import 'package:flutter/material.dart';


// All import to define routes
import 'package:ba_locale/view/createAccount.dart' show CreateAccount;
import 'package:ba_locale/view/app.dart' show AppPage;
import 'package:ba_locale/view/login.dart' show Login;
  //For drawers
import 'package:ba_locale/view/drawer/presentation.dart' show Presentation;
import 'package:ba_locale/view/bottomBar/maps.dart' show MapsPage;
import 'package:ba_locale/view/drawer/manual.dart' show Manual;
import 'package:ba_locale/view/drawer/help.dart' show HelpPage;

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {

  const MainApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Bienvenue sur la BA locale !';

    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.light,
//          brightness: Brightness.dark,
          canvasColor: ThemeDesign.interfaceColor,
          scaffoldBackgroundColor: ThemeDesign.backgroundColor,
          primaryColor: ThemeDesign.interfaceColor,
          //accentColor: ThemeDesign.backgroundColor,
          hintColor: ThemeDesign.interfaceTxtColor,
          buttonColor: ThemeDesign.interfaceColor,
          splashColor: ThemeDesign.interfaceColor,
          //hoverColor: ThemeDesign.backgroundColor,
          //cursorColor: ThemeDesign.backgroundColor,
          //secondaryHeaderColor: ThemeDesign.backgroundColor,


          // Define the default font family.
          fontFamily: 'Montserrat',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        //initialRoute: '/login',
        home: SplashPage(),
        routes: {
          '/login': (context) => Login(),
          '/createAccount': (context) => CreateAccount(),
          '/app': (context) => AppPage(),
          //Drawers routes
          '/app/presentation': (context) => Presentation(),
          '/app/maps': (context) => MapsPage(),
          '/app/manual': (context) => Manual(),
          '/app/help': (context) => HelpPage(),
        });
  }
}

//Design Library
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// All import to define routes
import 'package:ba_locale/view/createAccount.dart' show CreateAccount;
import 'package:ba_locale/view/app.dart' show AppPage;
import 'package:ba_locale/view/login.dart' show Login;
  //For drawers
import 'package:ba_locale/view/drawer/presentaion.dart' show Presentation;
import 'package:ba_locale/view/drawer/maps.dart' show Maps;
import 'package:ba_locale/view/drawer/manual.dart' show Manual;
import 'package:ba_locale/view/drawer/help.dart' show Help;

Future<void> main() async {
  //Enable camera:
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCam = cameras.first;
  runApp(MainApp(camera: firstCam));
}

class MainApp extends StatelessWidget {
  final CameraDescription camera;

  const MainApp({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Bienvenue sur la BA locale !';
    const Color _mainColor = Color(0xFF263F44);
    const Color _secColor = Color(0xFFFFF1CF);
    const Color _terColor = Color(0xFF015668);
    const Color _lastColor = Color(0xFFFFD369);

    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          /*canvasColor: _mainColor,
          scaffoldBackgroundColor: _secColor,
          primaryColor: _mainColor,
          accentColor: _mainColor,
          hintColor: _lastColor,
          buttonColor: _mainColor,
          hoverColor: _terColor,
          cursorColor: _mainColor,*/


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
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),
          '/createAccount': (context) => CreateAccount(),
          '/app': (context) => AppPage(camera: camera),
          //Drawers routes
          '/app/presentation': (context) => Presentation(),
          '/app/maps': (context) => Maps(),
          '/app/manual': (context) => Manual(),
          '/app/help': (context) => Help(),

        });
  }
}

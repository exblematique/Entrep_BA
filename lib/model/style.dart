/*
 * Contains all values to define application theme
 */
import 'package:flutter/material.dart';

abstract class ThemeDesign {
  static Color mainColor = const Color(0xFF00A896);
  static Color mainTxtColor = const Color(0xFFFFFFFF);

  static Color secColor = const Color(0xFF02C39A);
  static Color secTxtColor = const Color(0xFFFFFFFF);

  static Color backgroundColor = const Color(0xFFFFFFFF);

  static Color interfaceColor = const Color(0xFF02C39A);
  static Color interfaceTxtColor = const Color(0xFFFFFFFF);

  static TextStyle headerStyle = TextStyle(
    fontSize: 30,
    color: Colors.black,
    fontFamily: 'GlassAntiqua'
  );

  static TextStyle titleStyle = TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontFamily: 'FredokaOne',
    //fontWeight: FontWeight.bold,
  );

  static TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    height: 2,
    color: mainColor,
    fontFamily: 'Atma',
    fontWeight: FontWeight.bold,
  );

  static TextStyle paragraphStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontFamily: 'AlegreyaSans'
  );
}

abstract class ThemeActionDesign {
  static TextStyle titleStyle = TextStyle(
    fontSize: 20,
    color: Color(0xFF000000),
    fontFamily: 'Arial',
  );
}
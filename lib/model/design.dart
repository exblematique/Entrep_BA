//import 'dart:ui';
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

class InputDesign extends TextFormField {
  InputDesign(String hintText, {@required TextEditingController controller, String Function (String) validator, bool password = false})
      : super(
          style: TextStyle(color: ThemeDesign.interfaceColor),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: ThemeDesign.interfaceColor)
          ),
          controller: controller,
          obscureText: password,
          validator: (value) {
            if (validator != null) return validator(value);
            if (value.isEmpty) return "Merci d'entrer votre " + hintText;
            return null;
          },
      );
}

class ChangePageDesign extends RaisedButton {
  ChangePageDesign(String hintText, {@required String newPage, @required key, @required context})
  : super (
    child: Text(hintText),
    onPressed: () {
      if (key.currentState.validate())
        Navigator.pushNamed(context, newPage);
      else
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Veuillez remplir tous les champs')));
    },
  );
}

class ParameterValueDesign extends Column{
  ParameterValueDesign ({@required String parameter, @required String value})
    : super (
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          parameter,
          style: ThemeDesign.subtitleStyle
        ),
        Text(
          value,
          style: ThemeDesign.paragraphStyle,
          textAlign: TextAlign.justify
        ),
    ]);
}

class TextInterfaceDesign extends Text{
  TextInterfaceDesign (String text, {double size})
    : super (
      text,
      style: TextStyle(
        color: ThemeDesign.interfaceTxtColor,
        fontSize: size,
      )
    );
}

class TitrePageDesign extends Column {
  TitrePageDesign (String title)
  : super (
    mainAxisAlignment : MainAxisAlignment.start,
    crossAxisAlignment : CrossAxisAlignment.center,
    children: <Widget> [
      Image(
        image: AssetImage('assets/img/logo.png'),
        height: 100,
        width: 100,
      ),
      Text(
        title,
        style: ThemeDesign.headerStyle,
      ),
      Text("..................\n")
    ]
  );
}
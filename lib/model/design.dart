//import 'dart:ui';
import 'package:flutter/material.dart';

abstract class ThemeDesign {
  static Color mainColor = const Color(0xFF00A896);
  static Color mainTxtColor = const Color(0xFFFFFFFF);

  static Color secColor = const Color(0xFF02C39A);
  static Color secTxtColor = const Color(0xFFFFFFFF);

  static Color backgroundColor = const Color(0xFFFFFFFF);

  static Color interfaceColor = const Color(0xFF018C82);
  static Color interfaceTxtColor = const Color(0xFFFFFFFF);
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

class TextInterfaceDesign extends Text{
  TextInterfaceDesign (String text, {double size})
    : super (
      text,
      style: TextStyle(
        color: ThemeDesign.interfaceTxtColor,
        fontSize: size,
      ));
}
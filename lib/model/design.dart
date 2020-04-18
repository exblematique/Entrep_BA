/*
 * This file contain all generic designs
 * Design specific for one page are created directly where it used
 */

import 'package:ba_locale/model/style.dart';
import 'package:ba_locale/model/text.dart';
import 'package:flutter/material.dart';

class ParameterValueDesign extends Column{
  ParameterValueDesign ({@required String parameter, @required String value, bool center = false})
      : super (
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
        SizedBox(height: 10)
      ]);
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
        TextParagraphDesign("..................\n")
      ]
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

//This design is enabled for all sub-pages of the application
class ScaffoldDesign extends Scaffold {
  ScaffoldDesign({@required String title, @required Widget body, Widget floatingActionButton}) : super (
    appBar: AppBar(
        title: TextInterfaceDesign(title),
        centerTitle: true,
        iconTheme: IconThemeData(color: ThemeDesign.interfaceTxtColor)
    ),
    body: body,
    floatingActionButton: floatingActionButton
  );
}
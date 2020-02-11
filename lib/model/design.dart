//import 'dart:ui';
import 'package:flutter/material.dart';

class InputDesign extends TextFormField {
  InputDesign(String hintText, {@required TextEditingController controller, String Function (String) validator, bool password = false})
      : super(
          //style: TextStyle(color: Color(0xFF015668)),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hintText,
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



class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];
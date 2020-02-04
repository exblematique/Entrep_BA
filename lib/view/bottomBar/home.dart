//import 'package:ba_locale/model/app.dart';
import 'package:ba_locale/model/design.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InputDesign("Identifiant"),
        InputDesign("Nom"),
        InputDesign("Prénom"),
      ],
    );
  }
}


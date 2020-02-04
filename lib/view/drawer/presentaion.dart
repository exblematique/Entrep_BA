import 'package:flutter/material.dart';
import 'package:ba_locale/model/design.dart';

class Presentation extends StatefulWidget {
  @override
  PresentationState createState() => PresentationState();
}

class PresentationState extends State<Presentation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Création d'un compte"),
          centerTitle: true
      ),
      body: Builder(builder: (BuildContext context) {
        return Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InputDesign("Help"),
            ],
          ),
        );
      }),
    );
  }
}
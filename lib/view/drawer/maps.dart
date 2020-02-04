import 'package:flutter/material.dart';
import 'package:ba_locale/model/design.dart';

class Maps extends StatefulWidget {
  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<Maps> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Chercher un commençant"),
          centerTitle: true
      ),
      body: Builder(builder: (BuildContext context) {
        return Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InputDesign("Maps"),
            ],
          ),
        );
      }),
    );
  }
}
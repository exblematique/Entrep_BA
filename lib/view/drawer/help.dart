import 'package:flutter/material.dart';
import 'package:ba_locale/model/design.dart';

class Help extends StatefulWidget {
  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Help> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Centre d'aide"),
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

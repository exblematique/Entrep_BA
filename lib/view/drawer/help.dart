import 'package:flutter/material.dart';
import 'package:ba_locale/model/design.dart';

class HelpPage extends StatefulWidget {
  @override
  HelpPageState createState() => HelpPageState();
}

class HelpPageState extends State<HelpPage> {

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
              InputDesign("Help", controller: null),
            ],
          ),
        );
      }),
    );
  }
}

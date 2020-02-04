//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ba_locale/model/design.dart';

class CreateAccount extends StatefulWidget {
  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Création d'un compte"),
          centerTitle: true
      ),
      body: Builder(builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InputDesign("Identifiant"),
              InputDesign("Nom"),
              InputDesign("Prénom"),
              InputDesign("Date de naissance"),
              InputDesign("Adresse mail"),
              InputDesign("Mot de passe", password: true),
              InputDesign("Confirmation mot de passe", password: true),
              ChangePageDesign("Créer un compte",
                  newPage: '/home', key: _formKey, context: context),
            ],
          ),
        );
      }),
    );
  }
}

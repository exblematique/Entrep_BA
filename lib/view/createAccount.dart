import 'package:ba_locale/controller/splash.dart';
import 'package:ba_locale/model/design.dart';
import 'package:ba_locale/controller/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController pseudoController, firstNameController, lastNameController, birthController, emailController, pwdController, confirmPwdController;

  @override
  void initState() {
    pseudoController = new TextEditingController();
    firstNameController = new TextEditingController();
    lastNameController = new TextEditingController();
    birthController = new TextEditingController();
    emailController = new TextEditingController();
    pwdController = new TextEditingController();
    confirmPwdController = new TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ScaffoldDesign(
      title: "Création d'un compte",
      body: Builder(builder: (BuildContext context) {
        return Form(
          key: _registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InputDesign("Pseudo", controller: pseudoController),
              InputDesign("Nom", controller: lastNameController),
              InputDesign("Prénom", controller: firstNameController),
              InputDesign("Date de naissance", controller: birthController),
              InputDesign("Adresse mail", validator: emailValidator, controller: emailController),
              InputDesign("Mot de passe", validator: pwdValidator, password: true, controller: pwdController),
              InputDesign("Confirmation mot de passe", validator: pwdValidator, password: true, controller: confirmPwdController),
            RaisedButton(
              child: Text("Créer un compte"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                if (_registerFormKey.currentState.validate()) {
                  if (pwdController.text == confirmPwdController.text) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: pwdController.text)
                        .then((currentUser) => Firestore.instance
                        .collection("users")
                        .document(currentUser.user.uid)
                        .setData({
                      "pseudo": pseudoController.text,
                      "firstName": firstNameController.text,
                      "lastName": lastNameController.text,
                      "email": emailController.text,
                      "birthDate": birthController.text,
                      "nbPoints": 0
                    }).then((result) => {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SplashPage()),
                              (_) => false),
                      pseudoController.clear(),
                      firstNameController.clear(),
                      lastNameController.clear(),
                      birthController.clear(),
                      emailController.clear(),
                      pwdController.clear(),
                      confirmPwdController.clear()
                    }).catchError((err) => print(err)))
                    .catchError((err) => print(err));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Erreur"),
                            content: Text("Les mots de passe ne correspondent pas"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Fermer"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }
                }
              },
            ),
              ],
            ),
          );
        }),
      );
  }
}

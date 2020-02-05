//All widgets (generic and custom)
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ba_locale/model/design.dart';

class LoginApp extends Login {
  LoginApp({Key key}) : super(); //key: key);

  /// An external reference to the Controller if you wish. -gp
  //static final Con _controller = Con();

  //static MaterialApp _app;

  //static String get title => _app.title.toString();

  Widget build(BuildContext context) {
    final appTitle = 'Bienvenue sur la BA locale !';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Login(),
      ),
    );
  }
  //return _app;
}

// Create a Form widget.
class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String serverResponse = 'Server response';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: new Scaffold(
          appBar: AppBar(
            title: const Text('Bienvenue sur la BA locale !'),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/img/logo.png'),
                height: 200,
                width: 200,
              ),
              InputDesign("Identifiant"),
              InputDesign("Mot de passe", password: true),
              ChangePageDesign("Connexion",
                  newPage: '/app', key: _formKey, context: context),
              RaisedButton(
                onPressed: () {
                  //_makeGetRequest();
                  //_makeGetRequest(context);
                  Navigator.pushNamed(context, '/createAccount');
                },
                child: Text('Créer un compte'),
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(serverResponse),
              ),
              Test("Test", serverResponse, newPage: '/createAccount',
                  key: _formKey,
                  context: context),
               */
            ],
          ),
        ));
  }


  /*_makeGetRequest() async {
    Response response = await get(
        "http://agile.alwaysdata.net/identification.php?mail=test@esaip.org");
    print("Test: ");
    print(response.body);
    //Map<String, dynamic> json = jsonDecode(response.body);
    setState(() {
      serverResponse = response.body;
    });
  }*/
}
/*
class Test extends RaisedButton {
  Test(String hintText, String test, {@required String newPage, @required key, @required context})
      : super (
    child: Text(hintText),
    onPressed: () async {
      if (key.currentState.validate()) {
        Response response = await get(
            "http://agile.alwaysdata.net/identification.php?mail=test@esaip.org");
        test = response.body;
        Map<String, dynamic> json = jsonDecode(response.body);
        print("error: " + test);
        if (json['error'] == 0)
          Navigator.pushNamed(context, newPage);
      } else
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Veuillez remplir tous les champs')));
    },
  );
}*/
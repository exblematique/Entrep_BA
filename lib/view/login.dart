//All widgets (generic and custom)
import 'package:ba_locale/controller/splash.dart';
import 'package:ba_locale/model/validators.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ba_locale/model/design.dart';

class LoginApp extends Login {
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
}

// Create a Form widget.
class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController;
  TextEditingController pwdController;

  String serverResponse = 'Server response';

  @override
  initState() {
    emailController = new TextEditingController();
    pwdController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _loginFormKey,
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
              InputDesign("Email", controller: emailController),
              InputDesign("Mot de passe", validator: pwdValidator,
                  password: true,
                  controller: pwdController),
              RaisedButton(
                child: Text("Login"),
                //color: Theme.of(context).primaryColor,
                //textColor: Colors.white,
                onPressed: () {
                  if (_loginFormKey.currentState.validate())
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: pwdController.text)
                        .then((currentUser) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SplashPage()))
                            .catchError((err) => print(err));
                        });
                },
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createAccount');
                },
                child: Text('Créer un compte'),
              ),
            ],
          ),
        ));
  }
}
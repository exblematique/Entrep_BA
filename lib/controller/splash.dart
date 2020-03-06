import 'package:ba_locale/model/database/user.dart';
import 'package:ba_locale/view/app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    UserDB.clear();
    FirebaseAuth.instance
      .currentUser()
      .then((currentUser) {
      if (currentUser == null)
        Navigator.pushReplacementNamed(context, "/login");
      else {
        UserDB.waitToReady().then((_) =>
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AppPage(
                      )))
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
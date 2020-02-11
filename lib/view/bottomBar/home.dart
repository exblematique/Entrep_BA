//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  final String uid;

  HomePage({Key key, this.title, this.uid}) : super (key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  FirebaseUser currentUser;
//
//  @override
//  initState() {
//    this.getCurrentUser();
//    super.initState();
//  }
//
//  void getCurrentUser() async {
//    currentUser = await FirebaseAuth.instance.currentUser();
//  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
            image: AssetImage('assets/img/explaination.png')
        ),
      ],
    );
  }
}


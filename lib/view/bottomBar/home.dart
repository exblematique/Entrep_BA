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
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation){
        if (orientation == Orientation.landscape)
          return Center(child: Image(image: AssetImage('assets/img/explaination.png')));
        return ListView(
          children: <Widget>[
            Image(image: AssetImage('assets/img/acceuil_1.png')),
            Image(image: AssetImage('assets/img/acceuil_2.png')),
        ]);
      }
    );
  }
}


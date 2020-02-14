import 'package:ba_locale/model/design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActionPage extends StatefulWidget {
  ActionPage({Key key}) : super(key: key);
  _ActionPageState createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
   List<ActionDesign> _actions = new List<ActionDesign>();

  @override
  void initState() {
    //Downloading all actions and created design items
     Firestore.instance
        .collection("actions")
        .getDocuments()
        .then((QuerySnapshot actions) {
       _actions.add(ActionDesign(uid: "test", name: "test", description: "test"));
       for (DocumentSnapshot key in actions.documents.toList())
         _actions.add(ActionDesign(
             uid: key.documentID,
             name: key.data['name'],
             description: key.data['description']
         ));

     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: _actions,
    );
  }
}

class ActionDesign extends StatelessWidget{
  final bool _isEnabled = false;
  final String uid;
  final String name;
  final String description;

  ActionDesign({
    Key key,
    @required this.uid,
    @required this.name,
    @required this.description
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _isEnabled ? InputDesign("true") : InputDesign("false"),
        InputDesign("Action"),
      ],
    );
  }
}
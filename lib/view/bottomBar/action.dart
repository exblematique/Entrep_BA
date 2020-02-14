import 'package:ba_locale/model/design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class ActionPage extends StatefulWidget {
  ActionPage({Key key}) : super(key: key);
  _ActionPageState createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  List<ActionDesign> _actions = new List<ActionDesign>();

   //Downloading all actions
  Future<QuerySnapshot> downloadData() async {
    return await Firestore.instance
        .collection("actions")
        .getDocuments();
  }

  //Creating all ActionDesign widget and add it to _actions
  void createDesign(List<DocumentSnapshot> actions){
      _actions.clear();
      bool odd = false;
      for (DocumentSnapshot key in actions) {
        _actions.add(ActionDesign(
          uid: key.documentID,
          name: key.data['name'],
          description: key.data['description'],
          color: odd ? Color(0xFFDDFFDD) : Color(0xFFCCFFCC)
        ));
        odd = !odd;
      }
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: downloadData(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.data == null) return Text("Actions en cours de téléchargement.... Veuillez patienter....");
        createDesign(snapshot.data.documents);
        return ListView(
          children: _actions,
        );
      },
    );
  }
}

class ActionDesign extends StatefulWidget {
  final String uid;
  final String name;
  final String description;
  final Color color;

  ActionDesign({Key key,
    @required this.uid,
    @required this.name,
    @required this.description,
    @required this.color
  }) : super(key: key);
  _ActionDesignState createState() => _ActionDesignState();
}

class _ActionDesignState extends State<ActionDesign>{
  bool _isEnabled = false;

  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 10),
                child: Text(widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              RaisedButton(
                child: Icon(Icons.arrow_drop_down),
                onPressed: (){setState(() {_isEnabled = !_isEnabled;});}
              )
            ]
          ),
          _isEnabled ? descriptionDisplay() : Divider()
        ],
      ));
  }

  Widget descriptionDisplay (){
    return Column(children: <Widget>[
        Text(widget.description),
        Text(""),
        RaisedButton(
          child: Text("Participer à la bonne action"),
          onPressed: (){}
        ),
        Divider()
      ]
    );
  }
}
import 'package:ba_locale/model/database/user.dart';
//import 'package:ba_locale/model/validators.dart';
import 'package:flutter/material.dart';
import 'package:ba_locale/model/design.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //Creating all ActionDesign widget and add it to _actions
  List<Widget> createDesign() {
    List<Widget> output = <Widget>[
      InputDesign(User.firstName, validator: null, controller: null),
      InputDesign(User.lastName, validator: null, controller: null),
      InputDesign(User.birthDate, validator: null, controller: null),
      InputDesign(User.email, validator: null, controller: null),
      InputDesign(User.nbPoints.toString(), validator: null, controller: null)
    ];
    if (User.companies.length > 0)
      output.add(InputDesign(User.companies[0].name, validator: null, controller: null));
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: User.waitToReady(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if (snapshot.data == null) return Text("Profil de l'utilisateur en cours de téléchargement.... Veuillez patienter....");
        return ListView(
          children: snapshot.data ? createDesign() : <Widget>[Text("Il y a une erreur pendant le chargement des informations.... Réessayer plus tard !")],
        );
      },
    );
  }
}
//
//class ActionDesign extends StatefulWidget {
//  final String uid;
//  final String name;
//  final String description;
//  final Color color;
//
//  ActionDesign({Key key,
//    @required this.uid,
//    @required this.name,
//    @required this.description,
//    @required this.color
//  }) : super(key: key);
//  _ActionDesignState createState() => _ActionDesignState();
//}
//
//class _ActionDesignState extends State<ActionDesign>{
//  bool _isEnabled = false;
//
//  Widget build(BuildContext context) {
//    return Container(
//        color: widget.color,
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Padding(padding: EdgeInsets.only(left: 10),
//                    child: Text(widget.name,
//                      style: TextStyle(fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                  RaisedButton(
//                      child: Icon(Icons.arrow_drop_down),
//                      onPressed: (){setState(() {_isEnabled = !_isEnabled;});}
//                  )
//                ]
//            ),
//            _isEnabled ? descriptionDisplay() : Divider()
//          ],
//        ));
//  }
//
//  Widget descriptionDisplay (){
//    return Column(children: <Widget>[
//      Text(widget.description),
//      Text(""),
//      RaisedButton(
//          child: Text("Participer à la bonne action"),
//          onPressed: (){}
//      ),
//      Divider()
//    ]
//    );
//  }
//}
import 'package:ba_locale/model/database/company.dart';
import 'package:ba_locale/model/database/user.dart';
import 'package:ba_locale/view/bottomBar/subView/ManageAction.dart';
//import 'package:ba_locale/model/validators.dart';
import 'package:flutter/material.dart';
import 'package:ba_locale/model/design.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> parameterList = UserDB.getAlterable();
  Map<String, TextEditingController> controllers = new Map<String, TextEditingController>();

  //Creating all ActionDesign widget and return this
  List<Widget> createDesign() {
    List<Widget> output = new List<Widget>();
    for (String param in parameterList.keys.toList()) {
      controllers[param] = new TextEditingController(text: parameterList[param]);
      output.add(ProfileDesign(parameter: param, controller: controllers[param]));
    }
    for (int i=0; i<UserDB.companies.length; i++)
      output.add(CompanyDesign(UserDB.companies[i]));
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserDB.waitToReady(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if (snapshot.data == null) return Text("Profil de l'utilisateur en cours de téléchargement.... Veuillez patienter....");
        return ListView(
          children: snapshot.data ? createDesign() : <Widget>[Text("Il y a une erreur pendant le chargement des informations.... Réessayer plus tard !")]
        );
      },
    );
  }
}

class ProfileDesign extends StatelessWidget{
  final String parameter;
  final TextEditingController controller;

  ProfileDesign({
    Key key,
    @required this.parameter,
    @required this.controller
  }) : super(key: key);

  Widget build(BuildContext context){
    List<Widget> output = new List<Widget>();
    output.add(Text(this.parameter));
    output.add(InputDesign(this.parameter, controller: controller));
    return Column(children: output);
  }
}

class CompanyDesign extends StatelessWidget{
  final CompanyDB company;

  CompanyDesign(this.company, {Key key}) : super(key: key);

  Widget build(BuildContext context){
    List<Widget> output = new List<Widget>();
    output.add(Text(this.company.name));
    output.add(RaisedButton(
        child: Text("Gérer les actions"),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => ManageActionPage(company: this.company)));
        })
    );
    output.add(RaisedButton(
        child: Text("Gérer les réductions"),
        onPressed: (){

        })
    );
    return Column(children: output);
  }
}
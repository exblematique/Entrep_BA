import 'package:ba_locale/model/database/company.dart';
import 'package:ba_locale/model/database/user.dart';
import 'package:ba_locale/model/design.dart';
import 'package:ba_locale/view/bottomBar/subView/ManageAction.dart';
import 'package:flutter/material.dart';
import 'package:ba_locale/model/style.dart';

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
    output.add(new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage('assets/img/logo.jpg'),
          height: 75,
        ),
        Padding(padding: EdgeInsets.only(left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProfileInformation(UserDB.firstName + " " + UserDB.lastName),
              ProfileInformation(UserDB.pseudo)
            ],
          ))
      ]
    ));
    output.add(SizedBox(height: 10));
    output.add(ProfileInformation(UserDB.birthDate, parameter: 'Date de naissance: '));
    output.add(ProfileInformation(UserDB.email, parameter: 'Adresse mail :'));
    output.add(ProfileInformation(UserDB.nbPoints.toString(), parameter: 'Nombre de points'));
    output.add(SizedBox(height: 10));

//TODO Clean
//    for (String param in parameterList.keys.toList()) {
//      controllers[param] = new TextEditingController(text: parameterList[param]);
//      output.add(ProfileDesign(parameter: param, controller: controllers[param]));
//    }
    if (UserDB.companies.length != 0) {
      output.add(Text("Gestion entreprise", style: ThemeDesign.titleStyle));
      for (int i = 0; i < UserDB.companies.length; i++)
        output.add(CompanyDesign(UserDB.companies[i]));
    }
    return output;
  }

  /*
   *Function to build the view of profile page.
   * Using ListView to manage problems with the bottom of the page
   */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserDB.waitToReady(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if (snapshot.data == null) return Text("Profil de l'utilisateur en cours de téléchargement.... Veuillez patienter....");
        if (!snapshot.data) return (Text("Il y a une erreur pendant le chargement des informations.... Réessayer plus tard !"));
        List<Widget> output = createDesign();
        return new ListView.builder(
          itemCount: output.length,
          itemBuilder: (BuildContext context, int index) {
            return new Center(child: output[index]);
          }
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
    this.controller
  }) : super(key: key);

  Widget build(BuildContext context){
    //List<Widget> output = new List<Widget>();
    return Text(
        this.parameter,
        style: ThemeDesign.paragraphStyle
    );
    //TODO CLEAN output.add(Text(this.parameter, style: ThemeDesign.titleStyle));
    //if (this.controller != null)
    //  output.add(InputDesign(this.parameter, controller: controller));
    //return Row(children: output);
  }
}

class CompanyDesign extends StatelessWidget{
  final CompanyDB company;

  CompanyDesign(this.company, {Key key}) : super(key: key);

  Widget build(BuildContext context){
    List<Widget> output = new List<Widget>();
    output.add(Text(this.company.name));
    output.add(RaisedButton(
        child: Text(
            "Gérer les actions"
        ),
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

/*
 * Allow using only one class for all text on this page
 * Reusing ParameterValueDesign which contain size and color
 */
class ProfileInformation extends StatelessWidget {
  final String value, parameter;

  ProfileInformation(this.value, {this.parameter});

  Widget build (BuildContext context) {
    if (parameter == null)
      return Text(value);
    return ParameterValueDesign(
      parameter: this.parameter,
      value: this.value,
      center: true
    );
  }
}
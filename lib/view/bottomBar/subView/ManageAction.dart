import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/database/company.dart';
import 'package:ba_locale/model/style.dart';
import 'package:flutter/material.dart';

class ManageActionPage extends StatefulWidget {
  final CompanyDB company;
  ManageActionPage({Key key, @required this.company}) : super(key: key);
  _ManageActionPageState createState() => _ManageActionPageState();
}

class _ManageActionPageState extends State<ManageActionPage> {
  bool takePicture = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Gérer les actions"),
            centerTitle: true
        ),
        body: createDesign());
  }

  Column createDesign() {
    List<Widget> output = new List<Widget>();
    output.add(RaisedButton(
      child: Text("Ajouter une action"),
      onPressed: () {},
    ));
    bool odd = false;
    if (widget.company.actions.isEmpty)
      output.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("Vous n'avez aucune action de disponible, essayez d'en créer une !")]
      ));
    else
      for (ActionDB action in widget.company.actions) {
        output.add(ActionDesign(
            action: action,
            color: odd ? ThemeDesign.mainColor : ThemeDesign.secColor
        ));
        odd = !odd;
      }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: output,
    );
  }
}


class ActionDesign extends StatefulWidget {
  final ActionDB action;
  final Color color;

  ActionDesign({Key key,
    @required this.action,
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
                    child: Text(widget.action.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  RaisedButton(
                      child: Icon(Icons.arrow_drop_down),
                      onPressed: () => setState(() => _isEnabled = !_isEnabled)
                  )
                ]
            ),
            _isEnabled ? descriptionDisplay() : Text("")
          ],
        ));
  }

  Widget descriptionDisplay (){
    return Column(children: <Widget>[
      Text(widget.action.description),
      RaisedButton(
          child: Text("Supprimer cette action"),
          onPressed: () async {
            await widget.action.delete();
          }
      ),
    ]
    );
  }
}
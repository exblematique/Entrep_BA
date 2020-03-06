
import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/design.dart';
import 'package:ba_locale/view/photo/photo.dart';
import 'package:ba_locale/view/photo/qrcode.dart';
import 'package:flutter/material.dart' show AssetImage, AsyncSnapshot, BuildContext, Color, Column, Container, CrossAxisAlignment, EdgeInsets, FontWeight, FutureBuilder, Icon, Icons, Image, Key, ListView, MainAxisAlignment, MaterialPageRoute, Navigator, Padding, RaisedButton, Row, State, StatefulWidget, Text, TextStyle, Widget, required;

class ActionPage extends StatefulWidget {
  ActionPage({Key key}) : super(key: key);
  _ActionPageState createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  bool takePicture = false;
  //Creating all ActionDesign widget and return this
  List<ActionDesign> createDesign() {
    List<ActionDesign> output = new List<ActionDesign>();
    bool odd = false;
    for (ActionDB action in ActionsDB.availableList) {
      output.add(ActionDesign(
          action: action,
          color: odd ? ThemeDesign.mainColor : ThemeDesign.secColor
      ));
      odd = !odd;
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ActionsDB.waitToReady(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        List<Widget> output = new List<Widget>();
        output.add(TitrePageDesign("Les actions à réaliser"));
        if (snapshot.hasData) {
          List<ActionDesign> actions = createDesign();
          for (ActionDesign action in actions)
            output.add(action);
        }
        else if (snapshot.hasError)
          output.add(Text('Il y a une erreur : ${snapshot.error}'));
        else
          output.add(Text("Actions en cours de téléchargement.... Veuillez patienter...."));
        return ListView(children: output);
      },
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
              Image(
                image: AssetImage('assets/img/logo.png'),
                height: 75,
              ),
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
          _isEnabled ? descriptionDisplay() : Container()//Text("")
        ],
      ));
  }
  String done = "";
  Widget descriptionDisplay (){
    return Column(children: <Widget>[
        Text(widget.action.description),
        Text("Entreprise: " + widget.action.company.name),
        RaisedButton(
          child: Text("Participer à la bonne action"),
          onPressed: () async {
            //TODO: For testing
//            try {
//              String barcode = await BarcodeScanner.scan();
//              setState(() => done = widget.action.validate(barcode).toString());
//            }
//            catch (e){
//              setState(() => done = e.toString());
//            }

            if (widget.action.qrcode == null || widget.action.qrcode == "")
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (BuildContext context) => PhotoPage(action: widget.action)
              ));
            else
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) => QrcodePage(action: widget.action)
              ));
          }
        ),
      ]
    );
  }
}
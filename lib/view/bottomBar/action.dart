
import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/design.dart';
import 'package:ba_locale/model/style.dart';
import 'package:ba_locale/view/photo/photo.dart';
import 'package:ba_locale/view/photo/qrcode.dart';
import 'package:flutter/material.dart' show Alignment, AssetImage, AsyncSnapshot, BoxDecoration, BoxFit, BuildContext, Color, Column, Container, CrossAxisAlignment, DecorationImage, EdgeInsets, FutureBuilder, Icon, Icons, Image, Key, ListView, MainAxisAlignment, MaterialPageRoute, Navigator, Padding, RaisedButton, Row, SizedBox, Stack, State, StatefulWidget, Text, TextAlign, Widget, required;
import 'package:flutter/widgets.dart';

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
          action: action
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

  ActionDesign({Key key,
    @required this.action,
  }) : super(key: key);

  _ActionDesignState createState() => _ActionDesignState();
}

class _ActionDesignState extends State<ActionDesign>{
  bool _isEnabled = false;

  Widget build(BuildContext context) {
    return Container(
      color: ThemeDesign.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image(
                image: AssetImage('assets/img/Bandeau_Action.png'),
                height: 75,
                width: 500000, //This value enable to fill all width of the screen
                fit: BoxFit.fitWidth,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image(
                        image: widget.action.image == null ? AssetImage('assets/defaultImage/action.png') : widget.action.image.image,
                        height: 75,
                        width: 75,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(padding: EdgeInsets.only(left: 20),
                        child: Text(widget.action.name,
                          style: ThemeDesign.titleStyle,
                        ),
                      ),
                    ]),
                  SizedBox(
                    height: 75,
                    width: 50,
                    child: RaisedButton(
                      color: Color.fromRGBO(255, 0, 0, 0),
                      child: Icon(Icons.arrow_drop_down),
                      onPressed: () => setState(() => _isEnabled = !_isEnabled)
                    )
                  )
                ]
              ),
          ]),
          _isEnabled ? descriptionDisplay() : Container(),
          SizedBox(height: 10),
        ],
      ));
  }

  Widget descriptionDisplay (){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ParameterValueDesign(
          parameter: "Action à réaliser :",
          value: widget.action.description
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children : <Widget>[
            Column (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ParameterValueDesign(
                  parameter: "Entreprise :",
                  value: widget.action.company.name
                ),
                ParameterValueDesign(
                  parameter: "Lieu de l'action :",
                  value: widget.action.address == null ? widget.action.company.address : widget.action.address
                )
              ]),
              Row(children: <Widget>[
                Image(
                  image: widget.action.company.image == null ? AssetImage('assets/defaultImage/company.png') : widget.action.company.image.image,
                  height: 100,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                      "+ " + widget.action.nbPoints.toString() + "\npts",
                    textAlign: TextAlign.center,
                    style: ThemeDesign.titleStyle,
                  ),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: new AssetImage('assets/img/tache.png'),
                      fit: BoxFit.fill
                  )
                ))
              ])
        ]),
        SizedBox(height: 10),
        //Change button according to need scan QRCode or take action
        widget.action.qrcode == null || widget.action.qrcode == ""
        ? RaisedButton(
            child: Text("Prendre une photo de la bonne action"),
            onPressed: () async =>
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => PhotoPage(action: widget.action)
            ))
              //TODO: For testing
  //            try {
  //              String barcode = await BarcodeScanner.scan();
  //              setState(() => done = widget.action.validate(barcode).toString());
  //            }
  //            catch (e){
  //              setState(() => done = e.toString());
  //            }
        )
        : RaisedButton(
            child: Text("Récuperer le QRCode de la bonne action"),
            onPressed: () async =>
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => QrcodePage(action: widget.action)
            ))
        )
      ]
    );
  }
}
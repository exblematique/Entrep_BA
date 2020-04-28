import 'dart:typed_data';

import 'package:ba_locale/model/database/reduction.dart';
import 'package:ba_locale/model/database/user.dart';
import 'package:ba_locale/model/design.dart';
import 'package:ba_locale/model/style.dart';
import 'package:flutter/material.dart' show AlertDialog, Alignment, AssetImage, AsyncSnapshot, BoxDecoration, BoxFit, BuildContext, Color, Column, Container, CrossAxisAlignment, DecorationImage, EdgeInsets, FlatButton, FutureBuilder, Icon, Icons, Image, Key, ListView, MainAxisAlignment, Navigator, Padding, RaisedButton, Row, SizedBox, Stack, State, StatefulWidget, Text, TextAlign, Widget, required, showDialog;
import 'package:qrscan/qrscan.dart' as scanner;

class ReductionPage extends StatefulWidget {
  ReductionPage({Key key}) : super(key: key);
  _ReductionPageState createState() => _ReductionPageState();
}

class _ReductionPageState extends State<ReductionPage> {
  bool takePicture = false;
  //Creating all ActionDesign widget and return this
  List<ReductionDesign> createDesign() {
    List<ReductionDesign> output = new List<ReductionDesign>();
    bool odd = false;
    for (ReductionDB reduction in ReductionsDB.availableList) {
      output.add(ReductionDesign(
          reduction: reduction,
      ));
      odd = !odd;
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: ReductionsDB.waitToReady(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        List<Widget> output = new List<Widget>();
        output.add(TitrePageDesign("Les réductions disponibles"));
        if (snapshot.hasData) {
          List<ReductionDesign> reductions = createDesign();
          for (ReductionDesign reduction in reductions)
            output.add(reduction);
        }
        else if (snapshot.hasError)
          output.add(Text('Il y a une erreur : ${snapshot.error}'));
        else
          output.add(Text("Réductions en cours de téléchargement.... Veuillez patienter...."));
        return ListView(children: output);
      },
    );
  }
}

class ReductionDesign extends StatefulWidget {
  final ReductionDB reduction;

  ReductionDesign({Key key,
    @required this.reduction,
  }) : super(key: key);

  _ReductionDesignState createState() => _ReductionDesignState();
}

class _ReductionDesignState extends State<ReductionDesign>{
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
                image: AssetImage('assets/img/Bandeau_Reduction.png'),
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
                        image: widget.reduction.image == null ? AssetImage('assets/defaultImage/reduction.png') : widget.reduction.image.image,
                        height: 75,
                        width: 75,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(padding: EdgeInsets.only(left: 20),
                        child: Text(widget.reduction.name,
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
              parameter: "Réduction disponibles :",
              value: widget.reduction.description
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
                          value: widget.reduction.company.name
                      ),
                      ParameterValueDesign(
                          parameter: "Lieu pour utiliser la réduction :",
                          value: widget.reduction.company.address
                      )
                    ]),
                Row(children: <Widget>[
                  Image(
                    image: widget.reduction.company.image == null ? AssetImage('assets/defaultImage/company.png') : widget.reduction.company.image.image,
                    height: 100,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "-" + widget.reduction.nbPoints.toString() + "\npts",
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
          //Affiche un bouton actif si le nombre de points disponible est suffisant
          widget.reduction.nbPoints > UserDB.nbPoints
          ? RaisedButton(
              child: Text("Vous n'avez pas assez de points"),
              onPressed: null,
          )
          : RaisedButton(
              child: Text("Utiliser la réduction"),
              onPressed: () async {
                  //If variable QRCode doesn't exist, use UID of reduction instead
                  String qrcode = widget.reduction.qrcode == "" || widget.reduction.qrcode == null
                  ? widget.reduction.uid
                  : widget.reduction.qrcode;
                  Uint8List image = await scanner.generateBarCode(qrcode);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                        new AlertDialog(
                          title: new Text("QRCode pour la réduction"),
                          content: new Image.memory(image),
                          actions: <Widget> [
                            new FlatButton(
                              child: new Text("Fermer"),
                              onPressed: () => Navigator.of(context).pop()
                          )]
                    )
                  ).then((_) => UserDB.addPoints(-widget.reduction.nbPoints));
              }
          ),
          SizedBox(height: 30),
        ]
    );
  }
}
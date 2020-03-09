import 'package:ba_locale/model/database/reduction.dart';
import 'package:ba_locale/model/design.dart';
import 'package:flutter/material.dart' show Alignment, AssetImage, AsyncSnapshot, BoxDecoration, BoxFit, BuildContext, Column, Container, CrossAxisAlignment, DecorationImage, EdgeInsets, FutureBuilder, Icon, Icons, Image, Key, ListView, MainAxisAlignment, Padding, RaisedButton, Row, SizedBox, Stack, State, StatefulWidget, Text, TextAlign, Widget, required;

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
    for (ReductionDB action in ReductionsDB.availableList) {
      output.add(ReductionDesign(
          reduction: action,
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
        output.add(TitrePageDesign("Les réductions"));
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
                    //height: 75,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/img/logo.jpg'),
                          height: 75,
                        ),
                        Padding(padding: EdgeInsets.only(left: 10),
                          child: Text(widget.reduction.name,
                            style: ThemeDesign.titleStyle,
                          ),
                        ),
                        RaisedButton(
                            child: Icon(Icons.arrow_drop_down),
                            onPressed: () => setState(() => _isEnabled = !_isEnabled)
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
              parameter: "Réduction :",
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
                          value: widget.reduction.place
                      )
                    ]),
                Row(children: <Widget>[
                  Image.asset('assets/img/logo.jpg', height: 100),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.reduction.nbPoints.toString() + "\npts",
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
          RaisedButton(
              child: Text("Utiliser la réduction"),
              onPressed: () async {
                //TODO: For testing
//            try {
//              String barcode = await BarcodeScanner.scan();
//              setState(() => done = widget.action.validate(barcode).toString());
//            }
//            catch (e){
//              setState(() => done = e.toString());
//            }

//                if (widget.reduction.qrcode == null || widget.reduction.qrcode == "")
//                  Navigator.pushReplacement(context, MaterialPageRoute(
//                      builder: (BuildContext context) => PhotoPage(action: widget.action)
//                  ));
//                else
//                  Navigator.pushReplacement(context, MaterialPageRoute(
//                      builder: (BuildContext context) => QrcodePage(action: widget.action)
//                  ));
              }
          ),
          SizedBox(height: 30),
        ]
    );
  }
}
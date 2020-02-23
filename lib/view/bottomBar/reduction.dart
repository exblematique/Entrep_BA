import 'package:ba_locale/model/database/reduction.dart';
import 'package:ba_locale/model/design.dart';
import 'package:flutter/material.dart' show AsyncSnapshot, BuildContext, Color, Column, Container, CrossAxisAlignment, EdgeInsets, FontWeight, FutureBuilder, Icon, Icons, Key, ListView, MainAxisAlignment, Padding, RaisedButton, Row, State, StatefulWidget, Text, TextStyle, Widget, required;

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
      future: ReductionsDB.waitToReady(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if (snapshot.data == null) return Text("Réductions en cours de téléchargement.... Veuillez patienter....");
        return ListView(
            children: snapshot.data ? createDesign() : <Text>[Text("Il y a eu une erreur pendant le chargement des informations.... Réessayer plus tard !")]
        );
      },
    );
  }
}

class ReductionDesign extends StatefulWidget {
  final ReductionDB action;
  final Color color;

  ReductionDesign({Key key,
    @required this.action,
    @required this.color
  }) : super(key: key);

  _ReductionDesignState createState() => _ReductionDesignState();
}

class _ReductionDesignState extends State<ReductionDesign>{
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
  String done = "";
  Widget descriptionDisplay (){

    return Column(children: <Widget>[
      Text(widget.action.description),
      Text(done),
      RaisedButton(
          child: Text("Obtenir une réduction"),
          onPressed: () async {
            //TODO: For testing
//            try {
//              String barcode = await BarcodeScanner.scan();
//              setState(() => done = widget.action.validate(barcode).toString());
//            }
//            catch (e){
//              setState(() => done = e.toString());
//            }

//            if (widget.action.qrcode == null || widget.action.qrcode == "")
//              Navigator.pushReplacement(context, MaterialPageRoute(
//                  builder: (BuildContext context) => PhotoPage(action: widget.action)
//              ));
//            else
//              Navigator.pushReplacement(context, MaterialPageRoute(
//                  builder: (BuildContext context) => QrcodePage(action: widget.action)
//              ));
          }
      ),
    ]
    );
  }
}
import 'package:ba_locale/model/design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ba_locale/model/style.dart';

class Presentation extends StatefulWidget {
  @override
  PresentationState createState() => PresentationState();
}

class PresentationState extends State<Presentation> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FAQDesign>>(
      future: createDesign(),
      builder: (BuildContext context, AsyncSnapshot<List<FAQDesign>> snapshot){
        List<Widget> output = new List<Widget>();
        output.add(TitrePageDesign("Foire aux questions"));
        if (snapshot.hasData) {
          for (FAQDesign action in snapshot.data)
            output.add(action);
        }
        else if (snapshot.hasError)
          output.add(Text('Il y a une erreur : ${snapshot.error}'));
        else
          output.add(Text("Actions en cours de téléchargement.... Veuillez patienter...."));
        return ScaffoldDesign(
          title: "Présentation",
          body: ListView(children: output)
        );
      },
    );
  }

  Future<List<FAQDesign>> createDesign() async {
    DocumentSnapshot questions = await Firestore.instance
      .collection("text")
      .document("presentation")
      .get();

    List<FAQDesign> output = new List<FAQDesign>();
    for (int i=0; i<questions.data['answers'].length; i++)
      output.add(
        new FAQDesign(
          question: questions.data['questions'][i],
          answer: questions.data['answers'][i])
      );
    return output;
  }
}

class FAQDesign extends Column {
  final String question, answer;
  FAQDesign({@required this.question, @required this.answer}) : super (
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget> [
      Text(
        question,
        style: ThemeDesign.subtitleStyle,
        textAlign: TextAlign.center,
      ),
      Container(
        color: ThemeDesign.interfaceColor,
        child: Text(
          answer,
          style: ThemeDesign.paragraphStyle,
          textAlign: TextAlign.justify,
        )
      ),
      SizedBox(height: 20),
    ]
  );
}
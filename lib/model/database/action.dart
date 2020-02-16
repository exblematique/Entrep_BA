import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Action{
  final String uid, company, name, description, qrcode;
  final DateTime startDate, endDate;
  final int nbPoints;

  Action({
    @required this.uid,
    @required this.company,
    @required this.name,
    @required this.description,
    @required this.nbPoints,
    this.startDate,
    this.endDate,
    this.qrcode,
  });
}

//Abstract class with all pieces of information on reduction
abstract class Actions{
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err =  false;
  static List<Action> actions = new List<Action>();

  //Check if data are downloaded
  //If not, try to download and return true if successful
  static Future<bool> waitToReady() async {
    if (!ready)
      await downloadData();
    return ready && !err;
  }

  static bool isReady(){
    return ready;
  }

  //Find element by UID
  static Action getElementbyUID (String uid){
    for (Action action in actions){
      if (action.uid == uid)
        return action;
    }
    return null;
  }

  static Future<void> downloadData() async{
    //Reset all states
    ready = false;
    err = false;

    //Downloading data
    //If success, update reductions list
    await Firestore.instance
        .collection("reductions")
        .getDocuments()
        .then((QuerySnapshot snapshot){
      actions.clear();
      for (DocumentSnapshot action in snapshot.documents)
        actions.add(new Action(
          uid: action.documentID,
          company: action.data['company'],
          name: action.data['name'],
          description: action.data['description'],
          nbPoints: action.data['nbPoints'],
          startDate: action.data['startDate'],
          endDate: action.data['endDate'],
          qrcode: action.data['qrcode'],
        ));
      ready = true;
    })
    .catchError((){err = true;});
  }
}

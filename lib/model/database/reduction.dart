import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Abstract class for reduction items
class Reduction{
  final String uid, company, name, description, qrcode;
  final DateTime startDate, endDate;
  final int nbPoints;

  Reduction({
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
abstract class Reductions{
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err =  false;
  static List<Reduction> reductions = new List<Reduction>();

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
  static Reduction getElementbyUID (String uid){
    for (Reduction reduction in reductions){
      if (reduction.uid == uid)
        return reduction;
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
        reductions.clear();
        for (DocumentSnapshot reduction in snapshot.documents)
          reductions.add(new Reduction(
            uid: reduction.documentID,
            company: reduction.data['company'],
            name: reduction.data['name'],
            description: reduction.data['description'],
            nbPoints: reduction.data['nbPoints'],
            startDate: reduction.data['startDate'],
            endDate: reduction.data['endDate'],
            qrcode: reduction.data['qrcode'],
          ));
        ready = true;
      })
      .catchError((){err = true;});
  }
}



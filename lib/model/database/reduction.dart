import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReductionDB{
  final String uid, company, name, description, qrcode;
  final DateTime startDate, endDate;
  final int nbPoints;

  ReductionDB({
    @required this.uid,
    @required this.company,
    @required this.name,
    @required this.description,
    @required this.nbPoints,
    this.startDate,
    this.endDate,
    this.qrcode,
  });

  bool validate(String qrcode) {
    if (qrcode == this.qrcode)
      return true;
    else
      return false;
  }
}

//Abstract class with all pieces of information on reduction
abstract class ReductionsDB{
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err =  false;
  static List<ReductionDB> availableList = new List<ReductionDB>();

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
  static ReductionDB getElementbyUID (String uid){
    for (ReductionDB action in availableList){
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
      availableList.clear();
      for (DocumentSnapshot action in snapshot.documents)
        availableList.add(new ReductionDB(
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
    }).catchError((_){err = true;});
  }
}

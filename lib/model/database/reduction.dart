/**
 * This page contains interaction with the database for actions
 * ReductionDB is a unique action
 * ReductionsDB contains all actions available in the database
 */
import 'package:ba_locale/model/database/company.dart';
import 'package:ba_locale/controller/script.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReductionDB{
  CompanyDB company;
  final String uid, name, description, qrcode;
  final Image image;
  final DateTime startDate, endDate;
  final int nbPoints;

  ReductionDB({
    @required this.uid,
    @required this.name,
    @required this.description,
    @required this.nbPoints,
    this.image,
    this.startDate,
    this.endDate,
    this.qrcode
  });

  Future<bool> delete() async => ReductionsDB.deleteItem(this);

  void addCompany(CompanyDB companyDB) {
    company = companyDB;
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
    for (ReductionDB reduction in availableList){
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
      availableList.clear();
      for (DocumentSnapshot reduction in snapshot.documents)
        availableList.add(new ReductionDB(
          uid: reduction.documentID,
          name: reduction.data['name'],
          description: reduction.data['description'],
          nbPoints: reduction.data['nbPoints'],
          startDate: reduction.data['startDate'],
          endDate: reduction.data['endDate'],
          qrcode: reduction.data['qrcode'],
          image: strToImage(reduction.data['image']),
        ));
      ready = true;
    }).catchError((_){err = true;});
  }

  static Future<bool> deleteItem(ReductionDB reduction) async {
    bool error = false;
    await Firestore.instance
        .collection("reductions")
        .document(reduction.uid)
        .delete()
//TODO remove reference
//    .then((_) async {
//        await Firestore.instance
//          .collection("companies")
//          .document(action.company.uid)
//          .updateData({})
//        availableList.remove(action);
//
//      })
        .catchError((_) => error = true);
    return !error;
  }
}

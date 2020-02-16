
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Abstract class for reduction items
class Company{
  final String company, name, description, qrcode;
  final DateTime startDate, endDate;
  final int nbPoints;

  Company({
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
abstract class Companies{
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err =  false;
  static List<Company> companies = new List<Company>();

  //Check if data are downloaded
  //If not, try to download and return true if successful
  static bool waitToReady(){
    if (!ready) {
      downloadData();
      while (!ready && !err)
        continue;
    }
    return ready && !err;
  }

  //Find element by UID
  static Company getElementbyUID (String uid){
    for (Company company in companies){
      if (company.name == uid)
        return company;
    }
    return null;
  }

  static bool isReady(){
    return ready;
  }

  static Future<void> downloadData() async{
    //Reset all states
    ready = false;
    err = false;

    //Downloading data
    //If success, update reductions list
    await Firestore.instance
        .collection("companies")
        .getDocuments()
        .then((QuerySnapshot snapshot){
      companies.clear();
      for (DocumentSnapshot reduction in snapshot.documents)
        companies.add(new Company(
          company: reduction.documentID,
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



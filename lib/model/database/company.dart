/**
 * This page contains interaction with the database for companies
 * CompanyDB is a unique action
 * CompaniesDB contains all companies available in the database
 */
import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/database/reduction.dart';
import 'package:ba_locale/controller/script.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Abstract class for company items
class CompanyDB{
  final String uid, name, description, qrcode;
  final DateTime startDate, endDate;
  final Image image;
  final int nbPoints;
  final List<ActionDB> actions;
  final List<ReductionDB> reductions;


  CompanyDB({
    @required this.uid,
    @required this.name,
    @required this.description,
    @required this.actions,
    @required this.reductions,
    @required this.nbPoints,
    this.image,
    this.startDate,
    this.endDate,
    this.qrcode,
  }){
    for (ActionDB action in actions)
      action.addCompany(this);
    for (ReductionDB reduction in reductions)
      reduction.addCompany(this);
  }
}

//Abstract class with all pieces of information on companies
abstract class CompaniesDB{
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err =  false;
  static List<CompanyDB> companies = new List<CompanyDB>();

  //Check if data are downloaded
  //If not, try to download and return true if successful
  static Future<bool> waitToReady() async {
    if (!ready)
      await downloadData();
    return ready && !err;
  }

  //Find element by UID
  static CompanyDB getElementbyUID (String uid){
    print(companies);
    for (CompanyDB company in companies){
      if (company.uid == uid)
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
    QuerySnapshot snapshot = await Firestore.instance
        .collection("companies")
        .getDocuments()
        .catchError((e){
          err = true;
          print(e);
        });
    if (err) return;
    companies.clear();

    for (DocumentSnapshot company in snapshot.documents) {
      List<ActionDB> actions = new List<ActionDB>();
      if (company.data['actions'] != null && company.data['actions'].isNotEmpty) {
        await ActionsDB.waitToReady();
        for (DocumentReference action in company.data['actions'])
          actions.add(ActionsDB.getElementbyUID(action.documentID));
      }

      List<ReductionDB> reductions = new List<ReductionDB>();
      if (company.data['reductions'] != null && company.data['reductions'].isNotEmpty) {
        await ReductionsDB.waitToReady();
        for (DocumentReference reduction in company.data['reductions'])
          reductions.add(ReductionsDB.getElementbyUID(reduction.documentID));
      }

      companies.add(new CompanyDB(
        uid: company.documentID,
        name: company.data['name'],
        description: company.data['description'],
        actions: actions,
        reductions: reductions,
        nbPoints: company.data['nbPoints'],
        startDate: company.data['startDate'],
        endDate: company.data['endDate'],
        qrcode: company.data['qrcode'],
        image: strToImage(company.data['image']),
      ));
    }
    ready = true;
    //})
  }
}



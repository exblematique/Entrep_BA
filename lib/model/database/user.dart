import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/database/company.dart';
import 'package:ba_locale/model/database/reduction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserDB {
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err = false;

  //Generic pieces of information
  static String uid, firstName, lastName, birthDate, email, pseudo;
  static int nbPoints;
  static List<CompanyDB> companies = new List<CompanyDB>();
  static List<ReductionDB> reductionsUsed = new List<ReductionDB>();
  static Map<ActionDB, bool> actionsDone = new Map<ActionDB, bool>();

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

  static Future<void> downloadData() async{
    //Reset all states
    ready = false;
    err = false;

    //Downloading data
    //If success, update user value else reset all values
    FirebaseUser currentUser = await FirebaseAuth.instance
      .currentUser()
      .catchError((e){
        err = true;
        print(e);
      });
    if (err) return;
    if (currentUser == null) {
      UserDB.clear();
      err = true;
      return;
    }
    DocumentSnapshot user = await Firestore.instance
      .collection("users")
      .document(currentUser.uid)
      .get()
      .catchError((e){
        err = true;
        print(e);
      });
    if (err) return;
    uid = currentUser.uid;
    pseudo = user.data['pseudo'];
    firstName = user.data['firstName'];
    lastName = user.data['lastName'];
    birthDate = user.data['birthDate'];
    email = user.data['email'];
    nbPoints = user.data['nbPoints'];

    //Update company
      if (await CompaniesDB.waitToReady()) {
         for (DocumentReference company in user.data['companies'])
          companies.add(CompaniesDB.getElementbyUID(company.documentID));
      } else err = true;
    //Update reductions
    if (user.data['reductionsUsed'] != null){
      if (await ReductionsDB.waitToReady()) {
        for (String reduction in user.data['reductions'])
          reductionsUsed.add(ReductionsDB.getElementbyUID(reduction));
      } else err = true;
    }
    //Update actions
    if (user.data['actionsDone'] != null){
      if (await ActionsDB.waitToReady()){
        for (String action in user.data['actionsDone'].keys().toList())
          actionsDone[ActionsDB.getElementbyUID(action)] = user.data['actionsDone'][action];
      } else err = true;
    }
    if (!err) ready = true;
  }

  //Resetting all values
  static void clear(){
    ready = false;
    err = false;
    uid = null;
    pseudo = null;
    firstName = null;
    lastName = null;
    birthDate = null;
    email = null;
    nbPoints = null;
    companies.clear();
    reductionsUsed.clear();
    actionsDone.clear();
  }

  static Map<String, String> getAlterable() {
    Map <String, String> output = new Map<String, String>();
    output["Pseudo"] = pseudo;
    output["Nom"] = lastName;
    output["Prénom"] = firstName;
    output["Date de naissance"] = birthDate;
    output["Adresse mail"] = email;
    return output;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut()
        .then((_) => clear());
  }

  //Function to add points for the current user in Firebase
  static Future<void> addPoints(int nbPoints) async {
    return Firestore.instance
        .collection("users")
        .document(uid)
        .updateData({"nbPoints": UserDB.nbPoints + nbPoints})
        .then((_) => UserDB.nbPoints += nbPoints);
  }
}
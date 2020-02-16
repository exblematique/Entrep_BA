import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/database/company.dart';
import 'package:ba_locale/model/database/reduction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class User {
  //This variable equal true when all data are downloaded
  static bool ready = false;
  static bool err = false;

  //Generic pieces of information
  static String firstName, lastName, birthDate, email;
  static int nbPoints;
  static List<Company> companies = new List<Company>();
  static List<Reduction> reductionsUsed = new List<Reduction>();
  static Map<Action, bool> actionsDone;

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
  //  .then((currentUser) => {
    if (currentUser == null) {
      clear();
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
        //.then((DocumentSnapshot user) async {
    firstName = user.data['firstName'];
    lastName = user.data['lastName'];
    birthDate = user.data['birthDate'];
    email = user.data['email'];
    nbPoints = user.data['nbPoints'];

    //Update company
    if (user.data['companies'] != null){
      if (await Companies.waitToReady()) {
        print(user.data['companies']);
        for (String company in user.data['companies'])
          companies.add(Companies.getElementbyUID(company));
      } else err = true;
    }
    //Update reductions
    if (user.data['reductionsUsed'] != null){
      if (await Reductions.waitToReady()) {
        for (String reduction in user.data['reductions'])
          reductionsUsed.add(Reductions.getElementbyUID(reduction));
      } else err = true;
    }
    //Update actions
    if (user.data['actionsDone'] != null){
      if (await Actions.waitToReady()){
        for (String action in user.data['actionsDone'].keys().toList())
          actionsDone[Actions.getElementbyUID(action)] = user.data['actionsDone'][action];
      } else err = true;
    }
    if (!err) ready = true;
  }

  //Resetting all values
  static void clear(){
    firstName = null;
    lastName = null;
    birthDate = null;
    email = null;
    nbPoints = null;
    companies.clear();
    reductionsUsed.clear();
    actionsDone.clear();
  }
}
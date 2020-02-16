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
  static bool waitToReady(){
    if (!ready) {
      downloadData();
      while (!ready && !err)
        continue;
    }
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
    FirebaseAuth.instance
      .currentUser()
      .then((currentUser) => {
        if (currentUser == null)
          clear()
        else{
          Firestore.instance
            .collection("users")
            .document(currentUser.uid)
            .get()
            .then((DocumentSnapshot user) {
              firstName = user['firstName'];
              lastName = user['lastName'];
              birthDate = user['birthDate'];
              email = user['email'];
              nbPoints = user['nbPoints'];

              //Update company
              if (user['company'] != null){
                if (Companies.waitToReady()) {
                  for (String company in user['company'])
                    companies.add(Companies.getElementbyUID(company));
                }
                //Update reductions
                if (user['reductionsUsed'] != null){
                  if (Reductions.waitToReady()) {
                    for (String reduction in user['reductions'])
                      reductionsUsed.add(Reductions.getElementbyUID(reduction));
                  }
                  //Update actions
                  if (user['actionsDone'] != null){
                    if (Actions.waitToReady()){
                      for (String action in user['actionsDone'].keys().toList())
                        actionsDone[Actions.getElementbyUID(action)] = user['actionsDone'][action];
                    } else err = true;
                  } else err = true;
                } else err = true;
              }
              ready = true;
            })
            .catchError((){err = true;})
        }
      })
      .catchError((){err = true;});
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
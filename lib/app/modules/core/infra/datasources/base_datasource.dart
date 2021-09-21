import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/resources/constants.dart';

class BaseDataSource {

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  DocumentReference getRefCurrentUser(String uid) {
    return firestore
        .collection(Constants.ENVIRONMENT)
        .doc(Constants.ENVIRONMENT_NOW)
        .collection("users").doc(uid);
  }

  handlerError(error, stack) {
    throw error;
  }

}
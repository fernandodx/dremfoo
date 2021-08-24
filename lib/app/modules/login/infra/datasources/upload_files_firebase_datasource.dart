import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/ilogin_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/iupload_files_datasource.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadFilesFirebaseDataSource implements IUploadFilesDataSource {

  Completer<String> _instance = Completer<String>();
  // Completer<FirebaseAuth> _auth = Completer<FirebaseAuth>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _init() async {

    Future.delayed(Duration(seconds: 2)).then((value) {
      _instance.complete(" FirebaseDataSource Finish");
    });

  }

  UploadFilesFirebaseDataSource(){
   _init();
  }

  Future exempleMethod() async {
    var value = await _instance.future;
  }


  @override
  Future<String> uploadFileAcountUser(String fireBaseUserUid, String nameFolder, File file, String id) async {
    try{
      final Reference refUser = FirebaseStorage.instance
          .ref()
          .child(nameFolder)
          .child(fireBaseUserUid);
      final Reference ref = refUser.child(id);

      UploadTask task = ref.putFile(file);
      final stream = task.snapshotEvents.listen((event) {
        print("UPLOAD FILE $id : ${event.hashCode}");
      });

      TaskSnapshot storageTask = await task.snapshot;
      stream.cancel();

      final urlImage = storageTask.ref.getDownloadURL();

      print("UPLOAD FILE SUCESS: $urlImage");
      return urlImage.toString();
    } catch(error){
      throw error;
    }
  }

  _handlerError(error, stack) {
    throw error;
  }

}
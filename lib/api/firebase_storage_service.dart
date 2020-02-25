import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_service.dart';

class FirebaseStorageService {
  Future<String> uploadFileUserOn(File file, {String id}) async {
    return uploadFile("users", file, id: id);
  }

  Future<String> uploadFileTemp(File file, {String id}) async {
    return uploadFile("temp", file, id: id);
  }

  Future<String> uploadFile(String refChild, File file, {String id}) async {
    try {
      final StorageReference refUser = FirebaseStorage.instance
          .ref()
          .child(refChild)
          .child("$fireBaseUserUid");
      final StorageReference ref = refUser.child(id ?? file.path);

      StorageUploadTask task = ref.putFile(file);
      final stream = task.events.listen((event) {
        print("UPLOAD FILE $id : ${event.type}");
      });

      StorageTaskSnapshot storageTask = await task.onComplete;
      stream.cancel();

      final urlImage = await storageTask.ref.getDownloadURL();

      print("UPLOAD IMAGE SUCESS: $urlImage");
      return urlImage.toString();
    } catch (error) {
      print("Erro no upload da image: $error");
      return "http://cdn2.iconfinder.com/data/icons/online-shop-outline/100/objects-07-512.png";
    }
  }

}

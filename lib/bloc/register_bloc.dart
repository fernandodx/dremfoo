import 'dart:async';
import 'dart:io';

import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/widget/alert_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'base_bloc.dart';

class RegisterBloc extends BaseBloc {
  final formKey = GlobalKey<FormState>();
  final user = User();
  final validatedEmailController = TextEditingController();

  final pictureStreamController = StreamController<Widget>();

  Stream get pictureStream => pictureStreamController.stream;

  void fetch() async {
//    if (user != null) {
//      urlPhotoUser = user.photoUrl;
//      nameTextController.text = user.displayName;
//      emailTextController.text = user.email;
//    }

    pictureStreamController.add(userPhotoEdit());
  }

  Future<FirebaseUser> resgisterUser(BuildContext context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      showLoading();

      ResponseApi responseApi = await FirebaseService()
          .createUserWithEmailAndPassword(context, user.email, user.password,
              name: user.name, photo: user.picture);

      hideLoading();

      if (responseApi.ok) {
        FirebaseUser user = responseApi.result;
        print("LOGIN REALIZADO: ${user.email} Foto: ${user.photoUrl}");
        return user;
      } else {
        alertBottomSheet(context,
            msg: responseApi.msg, title: "Ops", type: TypeAlert.ERROR);
        return null;
      }
    }
  }

  onAddImage() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      imageQuality: 80
    );

    user.picture = image;

    var circleImage = CircleAvatar(
      radius: 70,
      backgroundImage: Image.file(image).image,
    );

    var picture = Container(
      padding: EdgeInsets.all(3),
      child: circleImage,
    );

    pictureStreamController.sink.add(picture);
  }

  userPhotoEdit() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            "assets/images/icon_user.png",
            fit: BoxFit.contain,
            height: 60,
            width: 60,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                "assets/images/icon_edit.png",
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

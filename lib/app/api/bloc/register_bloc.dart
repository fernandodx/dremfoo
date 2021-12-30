import 'dart:async';
import 'dart:io';

import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/model/user.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/utils/analytics_util.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'base_bloc.dart';

class RegisterBloc extends BaseBloc<Widget> {
  final formKey = GlobalKey<FormState>();
  final user = UserRevo();
  final validatedEmailController = TextEditingController();

  void fetch() async {
    add(userPhotoEdit());
  }

  bool validFields(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (fieldsEquals(user.email!, validatedEmailController.text.toString())) {
        return true;
      } else {
        alertBottomSheet(context, msg: "O e-mail não confere",
            title: "Ops",
            type: TypeAlert.ERROR);
        return false;
      }
    }
    return false;
  }

  Future<User?> resgisterUser(BuildContext context) async {

    bool isOk = validFields(context);
    if(isOk){
      showLoading();
      ResponseApi responseApi = await FirebaseService()
          .createUserWithEmailAndPassword(context, user.email!, user.password!,
              name: user.name, photo: user.picture);
      hideLoading();
      if (responseApi.ok) {
        User user = responseApi.result;
        AnalyticsUtil.sendAnalyticsEvent(EventRevo.registerLogin, parameters: {"user":user.email});
        return user;
      } else {
        alertBottomSheet(context,
            msg: responseApi.stackMessage, title: "Ops", type: TypeAlert.ERROR);
        return null;
      }
     }
  }

  static bool fieldsEquals(String value, String value2) {
    if (value.isEmpty) {
      return false;
    }
    if(value != value2){
      return false;
    }
    return true;
  }

  onAddImage() async {
    var _pick = ImagePicker();

    final XFile image = await (_pick.pickImage(source: ImageSource.gallery, maxWidth: 300, imageQuality: 80) as FutureOr<XFile>);
    final File fileImg = File(image.path);

    user.picture = fileImg;

    var circleImage = CircleAvatar(
      radius: 70,
      backgroundImage: Image.file(fileImg).image,
    );

    var picture = Container(
      padding: EdgeInsets.all(3),
      child: circleImage,
    );

    add(picture);
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
            height: 40,
            width: 40,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(
                "assets/images/icon_edit.png",
                fit: BoxFit.contain,
                height: 20,
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
  dispose() {
    super.dispose();
  }
}

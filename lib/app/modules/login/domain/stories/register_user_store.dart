import 'dart:io';

import 'package:dremfoo/app/app_module.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/iregister_user_case.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'register_user_store.g.dart';

class RegisterUserStore = _RegisterUserStoreBase with _$RegisterUserStore;

abstract class _RegisterUserStoreBase with Store {
  IRegisterUserCase _registerUserCase;
  _RegisterUserStoreBase(this._registerUserCase);

  final formKey = GlobalKey<FormState>();
  final validatedEmailController = TextEditingController();
  final nameTextEditingController = TextEditingController();
  var user =  Modular.get<UserRevo>();

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  Widget? containerImage;

  void featch(UserRevo? userRevo) {
    if(userRevo != null) {
      nameTextEditingController.text = userRevo.name??"";
    }
  }



  @action
  onAddImage() async {
    var _pick = ImagePicker();

    final XFile? image = await _pick.pickImage(source: ImageSource.gallery, maxWidth: 300, imageQuality: 80);
    if (image != null) {
      final File fileImg = File(image.path);
      user.picture = fileImg;

      var picture = Container(
        padding: EdgeInsets.all(3),
        child: CircleAvatar(
          radius: 70,
          backgroundImage: Image.file(fileImg).image,
        ),
      );

      // add(picture); atualizar na view
      containerImage = picture;
    }
  }


  Future<void> resgisterUser(BuildContext context) async {
    bool isOk = validFields(context);
    if (isOk) {
      isLoading = true;
      ResponseApi responseApi = await _registerUserCase
          .createUserWithEmailAndPassword(context, user, photo: user.picture);
      if(responseApi.ok){
        Modular.to.navigate(AppModule.MODULE_HOME); //navegar para outro modulo
      }
      msgAlert = responseApi.messageAlert;
      isLoading = false;
    }
  }

  bool validFields(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (fieldsEquals(user.email!, validatedEmailController.text.toString())) {
        return true;
      } else {
        alertBottomSheet(context, msg: Translate.i().get.msg_error_email_diff, title: "Ops", type: TypeAlert.ERROR);
        return false;
      }
    }
    return false;
  }

  static bool fieldsEquals(String value, String value2) {
    if (value.isEmpty) {
      return false;
    }
    if (value != value2) {
      return false;
    }
    return true;
  }

}

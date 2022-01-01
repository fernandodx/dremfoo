import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/app_controller.dart';
import 'package:dremfoo/app/app_module.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/circle_avatar_user_revo_widget.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/iregister_user_case.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'register_user_store.g.dart';

class RegisterUserStore = _RegisterUserStoreBase with _$RegisterUserStore;

abstract class _RegisterUserStoreBase with Store {
  IRegisterUserCase _registerUserCase;
  ILoginCase _loginCase;
  _RegisterUserStoreBase(this._registerUserCase, this._loginCase);

  final formKey = GlobalKey<FormState>();
  final validatedEmailController = TextEditingController();
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  var user =  Modular.get<UserRevo>();
  var appController = AppController.getInstance();

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  Widget? containerImage;

  @observable
  bool isEdited = false;

  @observable
  Image? imageUser;

  @observable
  bool isThemeDark = false;

  @action
  void featch(UserRevo? userRevo) {
    if(userRevo != null) {
      isEdited = true;
      nameTextEditingController.text = userRevo.name??"";
      emailTextEditingController.text = userRevo.email??"";
      validatedEmailController.text = user.email??"";
      containerImage = CircleAvatarUserRevoWidget(urlImage: user.urlPicture, size: 85, isShowEdit: true,);
    }else{
      isEdited = false;
    }
  }



  @action
  Future<void> onAddImage() async {
    var _pick = ImagePicker();

    final XFile? image = await _pick.pickImage(source: ImageSource.gallery, maxWidth: 300, imageQuality: 80);
    if (image != null) {
      final File fileImg = File(image.path);
      imageUser = Image.file(fileImg);
      user.picture = fileImg;
      containerImage = CircleAvatarUserRevoWidget(image: Image.file(fileImg), size: 85, isShowEdit: true,);
    }
  }

  @action
  Future<void> updatePictureUser() async {
    var _pick = ImagePicker();
    final XFile? image = await _pick.pickImage(source: ImageSource.gallery, maxWidth: 300, imageQuality: 80);
    if (image != null) {
      final File fileImg = File(image.path);
      imageUser = Image.file(fileImg);
      user.picture = fileImg;
      _registerUserCase.updatePhotoUser(fileImg);
      
      containerImage = Container(
        width: 120,
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: CircleAvatarUserRevoWidget(
          radiusSize: 50,
          size: 90,
          isShowEdit: true,
          image: Image.file(fileImg),
        ),
      );
    }
  }


  @action
  Future<void> changeThemeDarkUser(bool isDark, BuildContext context) async {
    ResponseApi<bool> responseApi = await _registerUserCase.changeThemeDarkPrefsUser(isDark);
    if(responseApi.ok) {
      isThemeDark = responseApi.result!;
      appController.changeTheme(isThemeDark, context);
    }
  }

  Future<bool> isThemeDarkUser() async {
    ResponseApi<bool> responseApi = await _registerUserCase.isThemeDarkPrefsUser();
    if(responseApi.ok) {
      return responseApi.result!;
    }
    return false;
  }


  Future<void> _resgisterUser(BuildContext context) async {
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

  Future<void> _updateUser(BuildContext context) async {
    bool isOk = validFields(context);
    if (isOk) {
      isLoading = true;
      ResponseApi responseApi = await _registerUserCase.updateUser(user);
      msgAlert = responseApi.messageAlert;
      //A mensagem deve ser exibida primeiro
      if(responseApi.ok){
        Modular.to.pop();
      }
      isLoading = false;
    }
  }

  Future<void> logOut() async {
    isLoading = true;
    ResponseApi responseApi = await _loginCase.logOut();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      Modular.to.navigate("/userNotFound",);
    }
  }

  Future<void> confirmUser(BuildContext context) async {
    if(isEdited) {
      _updateUser(context);
    }else{
      _resgisterUser(context);
    }
  }


  bool validFields(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isEdited || fieldsEquals(user.email!, validatedEmailController.text.toString())) {
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

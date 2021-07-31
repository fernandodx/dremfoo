import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/login/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;
abstract class _LoginStoreBase with Store {

  ILoginCase _loginCase;
  _LoginStoreBase(this._loginCase);

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  String? navigation;


  final formKey = GlobalKey<FormState>();
  final UserRevo user = UserRevo();
  var textEmailController = TextEditingController();

  void rememberPassword(BuildContext context) async {
    isLoading = true;
    ResponseApi responseApi = await _loginCase.rememberPassword(textEmailController.text);
    if(responseApi.ok){
      if(responseApi.messageAlert != null){
        msgAlert = responseApi.messageAlert;
      }
    }else{
      msgAlert = responseApi.messageAlert;
    }
    isLoading = false;
  }

  loginWithGoogle(BuildContext context) async {
    // showLoading();
    ResponseApi responseApi =  await FirebaseService().loginWithGoogle(context);
    // hideLoading();
    checkResponseApiOnLogin(responseApi, context);
  }

  void loginWithFacebook(BuildContext context) async {
    // showLoading();
    ResponseApi responseApi = await FirebaseService().loginWithFacebook(context);
    // hideLoading();
    checkResponseApiOnLogin(responseApi, context);
  }

  void checkResponseApiOnLogin(ResponseApi responseApi, BuildContext context) {
    if (responseApi.ok) {
      User user = responseApi.result;
      print("LOGIN REALIZADO: ${user.email} Foto: ${user.photoURL}");
      goToHome(user, context);
    } else {
      alertBottomSheet(context,
          msg: responseApi.stackMessage,
          title: "Erro na Autenticação",
          type: TypeAlert.ERROR);
    }
  }

  Future<User?> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      print("Erro na validação");
      return null;
    }
    formKey.currentState!.save();

    // showLoading();
    ResponseApi responseApi = await FirebaseService()
        .loginWithEmailAndPassword(context, user.email!, user.password!);
    // hideLoading();
    checkResponseApiOnLogin(responseApi, context);
  }

  void goToHome(user, BuildContext context) {
    if (user != null) {
      // push(context, HomePage(), isReplace: true);
      // Modular.to.navigate("/"); //ARRUMAR
    }
  }




}
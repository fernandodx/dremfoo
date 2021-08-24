import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/login/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/modules/login/login_module.dart';
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
  User? userSingIn;

  final formKey = GlobalKey<FormState>();
  final UserRevo user = UserRevo();
  var textEmailController = TextEditingController();

  void rememberPassword(BuildContext context) async {
    isLoading = true;
    ResponseApi responseApi = await _loginCase.rememberPassword(textEmailController.text);
    msgAlert = responseApi.messageAlert;
    isLoading = false;
  }

  void onNotRegister() {
    Modular.to.pushNamed(LoginModule.REGISTER_PAGE);
  }

  void onLoginWithGoogle(BuildContext context) async {
    isLoading = true;
    ResponseApi<User> responseApi = await _loginCase.loginWithGoogle();
    handlerResponseApiUser(responseApi);
    msgAlert = responseApi.messageAlert;
    isLoading = false;

  }

  void onLoginWithFacebook(BuildContext context) async {
    isLoading = true;
    ResponseApi<User> responseApi = await _loginCase.loginWithFacebook();
    handlerResponseApiUser(responseApi);
    msgAlert = responseApi.messageAlert;
    isLoading = false;
  }

  Future<void> onLoginWithEmail(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return null;
    }
    formKey.currentState!.save();
    isLoading = true;
    ResponseApi<User> responseApi = await _loginCase.loginWithEmailAndPassword(user);
    handlerResponseApiUser(responseApi);
    msgAlert = responseApi.messageAlert;
    isLoading = false;
  }

  void handlerResponseApiUser(ResponseApi<User> responseApi) {
    if(responseApi.ok){
      userSingIn = responseApi.result;
    }
  }

}
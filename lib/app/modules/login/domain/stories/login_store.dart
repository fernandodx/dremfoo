import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/modules/login/login_module.dart';
import 'package:dremfoo/app/modules/login/ui/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  final formKey = GlobalKey<FormState>();
  late UserRevo user;
  var textEmailController = TextEditingController();

  void featch() {
    user = Modular.get<UserRevo>();
  }

  void rememberPassword(BuildContext context) async {
    isLoading = true;
    ResponseApi responseApi = await _loginCase.rememberPassword(textEmailController.text);
    msgAlert = responseApi.messageAlert;
    isLoading = false;
  }

  void onNotRegister(BuildContext context) {
    // Navigator.pushNamed(context, LoginModule.REGISTER_PAGE);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()),);
    // Modular.to.pushNamed(LoginModule.REGISTER_PAGE);
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
    isLoading = false;
    handlerResponseApiUser(responseApi);
  }

  void handlerResponseApiUser(ResponseApi<User> responseApi) {
    if(responseApi.ok){
      // userSingIn = responseApi.result;
      Modular.to.navigate("/home/dashboard");
    }else{
      msgAlert = responseApi.messageAlert;
    }
  }

}
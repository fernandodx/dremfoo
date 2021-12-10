import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/iregister_user_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../../app_controller.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;
abstract class _SplashStoreBase with Store {

  ILoginCase _loginCase;
  IRegisterUserCase _registerUserCase;
  _SplashStoreBase(this._loginCase, this._registerUserCase);

  var appController = AppController.getInstance();

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;


  @action
  Future<void> featch(BuildContext context) async {
    isLoading = true;
    checkTheme(context);
    ResponseApi<String> responseApi = await _loginCase.checkUserLoging();
    if(responseApi.ok){
      Modular.to.navigate("/home",);
    }else{
      //Navegar para tela de login
      Modular.to.navigate("/userNotFound",);
    }
    isLoading = false;
  }

  void checkTheme(BuildContext context) {
    _registerUserCase.isThemeDarkPrefsUser().then((responseApi){
      if(responseApi.ok) {
        var isThemeDark = responseApi.result!;
        appController.changeTheme(isThemeDark, context);
        // appController.notifierTheme.value = ThemeData.light();
      }
    });
  }
}
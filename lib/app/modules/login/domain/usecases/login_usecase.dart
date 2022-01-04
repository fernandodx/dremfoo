import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ishared_prefs_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/ilogin_repository.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/iregister_user_repository.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

import 'contract/ilogin_case.dart';

class LoginUseCase implements ILoginCase {

  ILoginRepository _loginRepository;
  IRegisterUserRepository _userRepository;
  ISharedPrefsRepository _sharedPrefsRepository;
  LoginUseCase(this._loginRepository, this._userRepository, this._sharedPrefsRepository);

  var _userRevo = Modular.get<UserRevo>();

  @override
  Future<ResponseApi<User>> loginWithEmailAndPassword(UserRevo userRevo) async {

    try {
      var user = await _loginRepository.signInWithEmailAndPassword(userRevo.email!, userRevo.password!);
      await _saveUserLoging(user.uid);
      _saveUser(_userRevo);
      saveLastAcessUser();


      return ResponseApi.ok(result: user);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<User>> loginWithFacebook() async {

    try {
      var user = await _loginRepository.signInWithFacebook();
      await _saveUserLoging(user.uid);
      _saveUser(_userRevo);
      saveLastAcessUser();

      return ResponseApi.ok(result: user);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<User>> loginWithGoogle() async {

    try {
      var user = await _loginRepository.signInWithGoogle();
      await _saveUserLoging(user.uid);
      _saveUser(_userRevo);
      saveLastAcessUser();

      return ResponseApi.ok(result: user);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi> rememberPassword(String? email) async {
    if (email == null || email.length <= 0) {
      var alert = MessageAlert.create(Translate.i().get.title_forgot_password, Translate.i().get.msg_fill_email, TypeAlert.ALERT);
      return ResponseApi.error(messageAlert: alert);
    }
    if (!email.contains("@") || !email.contains(".com")) {
      var alert =  MessageAlert.create(Translate.i().get.title_forgot_password, Translate.i().get.msg_email_invalid, TypeAlert.ALERT);
      return ResponseApi.error(messageAlert: alert);
    }

    try {

      await _loginRepository.sendResetPassword(email);
      var alert = MessageAlert.create(Translate.i().get.title_msg_sucess,  Translate.i().get.msg_sucess_forgot_password, TypeAlert.SUCESS);
      return ResponseApi.ok(messageAlert: alert);

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  Future<void> _saveUser(UserRevo user) async {
    DateTime now = DateTime.now();
    DateTime initTime = DateTime(now.year, now.month, now.day, Constants.HOUR_INIT_NOTIFICATION);
    DateTime finishTime = DateTime(now.year, now.month, now.day, Constants.HOUR_FINISH_NOTIFICATION);
    _userRepository.saveUser(user, initTime, finishTime);
  }

  Future<void> _saveUserLoging(String uid) async  {
    return _sharedPrefsRepository.putString("USER_LOG_UID", uid);
  }

  @override
  Future<ResponseApi> saveLastAcessUser() async {
    try{

      if(_userRevo.dateLastAcess != null
          && _userRevo.dateLastAcess!.toDate().isSameDate(DateTime.now())){
        return ResponseApi.ok();
      }

      if(_userRevo.uid != null){
        await _userRepository.saveLastAcessUser(_userRevo.uid!, Timestamp.now());
        return ResponseApi.ok();
      }

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<String>> checkUserLoging() async {
    try{
      
      String uid = await _sharedPrefsRepository.getString("USER_LOG_UID");
      if(uid.isNotEmpty) {
        return ResponseApi.ok(result: uid);
      }else{
        return ResponseApi.error(messageAlert: MessageAlert.create(Translate.i().get.title_msg_error, "Usuário não logado", TypeAlert.ALERT));
      }

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi> logOut() async {
    try{

      await _sharedPrefsRepository.removePref("USER_LOG_UID");
      await _loginRepository.logOut();
      _userRevo = new UserRevo();
      return ResponseApi.ok();

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }
    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }



}
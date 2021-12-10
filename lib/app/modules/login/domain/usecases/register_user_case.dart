import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ishared_prefs_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/level_revo.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_focus.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/iregister_user_case.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/iregister_user_repository.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class RegisterUserCase extends IRegisterUserCase {

  IRegisterUserRepository _userRepository;
  ISharedPrefsRepository _sharedPrefsRepository;
  RegisterUserCase(this._userRepository, this._sharedPrefsRepository);

  var _userRevo = Modular.get<UserRevo>();

  @override
  Future<ResponseApi<User>> createUserWithEmailAndPassword(BuildContext context, UserRevo userRevo, {File? photo}) async {

    try{
      var user = await _userRepository.createUserWithEmailAndPassword(context, userRevo);

      // MainEventBus().get(context).updateUser(user); -- vericar depois a reatividade ao se ter um novo user
      await _saveUser(userRevo);
      await _saveLastAcessUser();
      await _saveUserLoging(user.uid);

      if(photo != null){
        await uploadPhotoAcountUser(user.uid, photo);
      }

      var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_sucess_user_created, TypeAlert.SUCESS);
      return ResponseApi.ok(result: user, messageAlert: alert);

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    }on Exception catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  Future<void> _saveUser(UserRevo user) async {
    try{
      DateTime now = DateTime.now();
      DateTime initTime = DateTime(now.year, now.month, now.day, Constants.HOUR_INIT_NOTIFICATION);
      DateTime finishTime = DateTime(now.year, now.month, now.day, Constants.HOUR_FINISH_NOTIFICATION);
      _userRepository.saveUser(user, initTime, finishTime);
    } catch(error){
      throw error;
    }
  }

  @override
  Future<ResponseApi> updateUser(UserRevo user) async {
    try{
      DateTime now = DateTime.now();
      DateTime initTime = DateTime(now.year, now.month, now.day, Constants.HOUR_INIT_NOTIFICATION);
      DateTime finishTime = DateTime(now.year, now.month, now.day, Constants.HOUR_FINISH_NOTIFICATION);
      await _userRepository.updateUser(user, initTime, finishTime);
      return ResponseApi.ok();

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    }on Exception catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  Future<void> _saveUserLoging(String uid) async  {
    return _sharedPrefsRepository.putString("USER_LOG_UID", uid);
  }

  @override
  Future<ResponseApi<bool>> changeThemeDarkPrefsUser(bool isThemeDark) async {
    try{
      await _sharedPrefsRepository.putBool("THEME_DARK_USER", isThemeDark);
      return ResponseApi.ok(result: isThemeDark);
    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    }on Exception catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<bool>> isThemeDarkPrefsUser() async {
    try{
      var isThemeDark = await  _sharedPrefsRepository.getBool("THEME_DARK_USER", null);
      if(isThemeDark == null) {
        var alert = MessageAlert.create(Translate.i().get.title_msg_error, "Tema dark ainda não foi definido", TypeAlert.ALERT);
        return ResponseApi.error(messageAlert: alert);
      }

      return ResponseApi.ok(result: isThemeDark);

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    }on Exception catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }


  @override
  Future<ResponseApi> updatePhotoUser(File picture) async {
    try{

      String urlPhoto = await _userRepository.uploadFileAcountUser(_userRevo.uid, picture, "user_photo");
      await _userRepository.updatePhotoUser(_userRevo.uid, urlPhoto);
      return ResponseApi.ok();

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    }on Exception catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<String>> uploadPhotoAcountUser(String fireBaseUserUid, File file) async {
    try{

      String urlPhoto = await _userRepository.uploadFileAcountUser(_userRevo.uid, file, "user_photo");
      _userRevo.urlPicture = urlPhoto;
      _userRevo.userFirebase?.updatePhotoURL(urlPhoto);
      return ResponseApi.ok(result: urlPhoto);

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
  Future<ResponseApi<LevelRevo>> findLevelCurrent(int countDayFocus) async {
    try{

      List<LevelRevo> levels = await _userRepository.findLevelsWin(countDayFocus);
      return ResponseApi.ok(result: levels.first);

    }on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  //TODO REFATORAR
  @override
  Future<ResponseApi> updateContinuosFocus() async {
    try{

      UserFocus? userFocus = await _userRepository.findFocusUser(_userRevo.uid);
      if(userFocus != null && userFocus.dateLastFocus != null && userFocus.countDaysFocus != null) {

        DateTime dateLast = userFocus.dateLastFocus!.toDate();
        DateTime dateNow = DateTime.now();

        int countDayLast =  DateUtil().totalLengthOfDays(dateLast.month, dateLast.day, dateLast.year);
        int countDayNow=  DateUtil().totalLengthOfDays(dateNow.month, dateNow.day, dateNow.year);
        int count = countDayNow - countDayLast;

        if(count > 2) {
          //Reset Focus
          userFocus.dateLastFocus = Timestamp.now();
          userFocus.dateInit = Timestamp.now();
          userFocus.countDaysFocus = 1;

          ResponseApi<LevelRevo> responseApi = await findLevelCurrent(1);
          if(responseApi.ok) {
            LevelRevo level = responseApi.result!;
            level.countDaysFocus = 1;
            userFocus.level = level;
          }

          UserFocus userFocusUpdate = await _userRepository.updateFocusUser(_userRevo.uid, userFocus);
          return ResponseApi.ok(result: userFocusUpdate);

        }else{
          //increment Focus
          if(userFocus.dateLastFocus!.toDate().isSameDate(dateNow)){
            return ResponseApi.ok(result: userFocus);
          }

          var newCountDayFocus = userFocus.countDaysFocus! + 1;
          userFocus.dateLastFocus = Timestamp.now();
          userFocus.countDaysFocus = newCountDayFocus;

          ResponseApi<LevelRevo> responseApi = await findLevelCurrent(newCountDayFocus);
          if(responseApi.ok) {
            LevelRevo level = responseApi.result!;
            level.countDaysFocus = newCountDayFocus;
            userFocus.level = level;
          }

          UserFocus userFocusUpdate = await _userRepository.updateFocusUser(_userRevo.uid, userFocus);
          return ResponseApi.ok(result: userFocusUpdate);
        }

      }else{

        //Criar o primeiro UserFoco
        UserFocus focus = UserFocus();
        focus.countDaysFocus = 1;
        focus.dateLastFocus = Timestamp.now();
        focus.dateInit = Timestamp.now();

        ResponseApi<LevelRevo> responseApi = await findLevelCurrent(1);
        if(responseApi.ok) {
          LevelRevo level = responseApi.result!;
          level.countDaysFocus = 1;
          focus.level = level;
        }
        UserFocus userFocusUpdate = await _userRepository.updateFocusUser(_userRevo.uid, focus);
        return ResponseApi.ok(result: userFocusUpdate);
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


  Future<void> _saveLastAcessUser() async {
    try{
      if(_userRevo.uid != null){
         _userRepository.saveLastAcessUser(_userRevo.uid!, Timestamp.now());
      }
    } catch(error){
      throw error;
    }
  }




}
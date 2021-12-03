import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ishared_prefs_repository.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/iregister_user_case.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/iregister_user_repository.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';

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
      await saveUser(userRevo);
      await saveLastAcessUser();
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


  Future<void> saveUser(UserRevo user) async {
    try{
      DateTime now = DateTime.now();
      DateTime initTime = DateTime(now.year, now.month, now.day, Constants.HOUR_INIT_NOTIFICATION);
      DateTime finishTime = DateTime(now.year, now.month, now.day, Constants.HOUR_FINISH_NOTIFICATION);
      _userRepository.saveUser(user, initTime, finishTime);
    } catch(error){
      throw error;
    }
  }

  Future<void> _saveUserLoging(String uid) async  {
    return _sharedPrefsRepository.putString("USER_LOG_UID", uid);
  }

  @override
  Future<ResponseApi<String>> uploadPhotoAcountUser(String fireBaseUserUid, File file) async {
    try{

      String urlPhoto = await _userRepository.uploadFileAcountUser(fireBaseUserUid, file, "user_photo");
      _userRevo.urlPicture = urlPhoto;
      _userRevo.userFirebase?.updatePhotoURL(urlPhoto);
      //Atualizar foto profile Mobx
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

  Future<void> saveLastAcessUser() async {
    try{
      if(_userRevo.uid != null){
         _userRepository.saveLastAcessUser(_userRevo.uid!, Timestamp.now());
      }
    } catch(error){
      throw error;
    }
  }




}
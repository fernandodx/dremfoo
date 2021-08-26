import 'dart:io';

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/ilogin_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/iupload_files_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/iuser_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/iregister_user_repository.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterUserRepository extends IRegisterUserRepository {

  final ILoginDatasource _loginDatasource;
  final IUploadFilesDataSource _uploadFilesDataSource;
  final IUserDataSource _userDataSource;
  RegisterUserRepository(this._loginDatasource, this._uploadFilesDataSource, this._userDataSource);

  var _userRevo =  Modular.get<UserRevo>();
  var _analytics = Modular.get<RevoAnalytics>();

  @override
  Future<User> createUserWithEmailAndPassword(BuildContext context, UserRevo userRevo) async {
    try{
      var user = await _loginDatasource.createUserWithEmailAndPassword(userRevo.email!, userRevo.password!);
      if(user != null){
        user.updateDisplayName(userRevo.name);
      }

      await _userRevo.updateDataUserFirebase(user);

      if(user != null){
        _analytics.eventRegisterNewUser(email: _userRevo.email!, name: _userRevo.name!);
        _analytics.setUserPropertiesDefault(_userRevo);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("user == null"), msg: Translate.i().get.msg_error_generic_user_login);
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

      return user;

    } on PlatformException catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch (error.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          msg = Translate.i().get.msg_error_already_in_use;
          break;
        case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
          msg = Translate.i().get.msg_error_already_email_diff_credential;
          break;
        case 'ERROR_CREDENTIAL_ALREADY_IN_USE':
          msg = Translate.i().get.msg_error_already_credintial_in_use;
          break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);

    } on FirebaseAuthException catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch (error.code) {
        case 'email-already-in-use':
        case 'email-already-exists':
          msg = Translate.i().get.msg_error_already_in_use;
          break;
        case 'invalid-email':
          msg = Translate.i().get.msg_error_already_email_diff_credential;
          break;
        case 'ERROR_CREDENTIAL_ALREADY_IN_USE':
          msg = Translate.i().get.msg_error_already_credintial_in_use;
          break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: Translate.i().get.msg_error_generic_user_login);
    }
  }

  @override
  Future<String> uploadFileAcountUser(String fireBaseUserUid, File file, String id) async {
      return _uploadFilesDataSource.uploadFileAcountUser(fireBaseUserUid, "users", file, id).catchError((error, stack) {
        CrashlyticsUtil.logErro(error, stack);
        throw RevoExceptions.msgToUser(error: error, msg: Translate.i().get.msg_error_not_possible_upload_photo, stack:  stack);
      });
  }

  @override
  Future<Object> saveLastAcessUser(String fireBaseUserUid, Timestamp dateAcess) async {
      return _userDataSource.saveLastAcessUser(fireBaseUserUid, dateAcess).catchError((error, stack) {
        CrashlyticsUtil.logErro(error, stack);
        throw RevoExceptions.msgToUser(error: error, msg: Translate.i().get.msg_error_not_possible_upload_photo, stack:  stack);
      });
  }

  @override
  Future<void> saveUser(UserRevo user, DateTime initNotification, DateTime finishNotification) async {
    try{
      bool isExist = user.uid != null ? await _userDataSource.isUserUidExist(user.uid!) : false;
      if(!isExist){
        await _userDataSource.saveUser(user, initNotification, finishNotification);
      }
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
      throw RevoExceptions.msgToUser(error: Exception(error), msg: Translate.i().get.msg_error_not_possible_save_user, stack:  stack);
    }
  }

}
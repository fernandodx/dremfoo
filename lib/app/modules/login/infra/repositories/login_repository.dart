import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/ilogin_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/ilogin_repository.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginRepository implements ILoginRepository {

  final ILoginDatasource _loginDatasource;
  LoginRepository(this._loginDatasource);

  var _userRevo =  Modular.get<UserRevo>();
  var _analytics = Modular.get<RevoAnalytics>();


  @override
  Future<void> sendResetPassword(String email) async  {
    try{

      _analytics.eventForgotPassword(email);
      _loginDatasource.sendResetPassword(email);

    } on PlatformException catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch (error.code) {
        case 'ERROR_USER_NOT_FOUND':
          msg = Translate.i().get.msg_error_user_not_found;
          break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);

    } on FirebaseAuthException catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch (error.code) {
        case 'email-already-exists':
          msg = Translate.i().get.msg_error_already_in_use;
          break;
        case 'invalid-email':
          msg = Translate.i().get.msg_error_user_not_found;
          break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: Translate.i().get.msg_error_generic_user_login);
    }

  }

  @override
  Future<User> signInWithFacebook() async {
    try{

      var msgError = "";
      LoginResult result = await _loginDatasource.signInWithFacebook();
      switch(result.status){
        case LoginStatus.success:

          AuthCredential auth = FacebookAuthProvider.credential(result.accessToken!.token);
          var user = await _loginDatasource.signInWithCredential(auth);
          await _userRevo.updateDataUserFirebase(user);
          return _handlerUser(_userRevo, MethodLogin.facebook);

        case LoginStatus.cancelled:
          msgError = Translate.i().get.msg_error_sign_in_fb_cancelled;
          break;
        case LoginStatus.failed:
          msgError = Translate.i().get.msg_error_sign_in_fb_failed;
          break;
        case LoginStatus.operationInProgress:
          msgError = Translate.i().get.msg_error_sign_in_fb_in_progress;
          break;

      }

      RevoExceptions _revoExceptions = new RevoExceptions
          .msgToUser(error: Exception(result.message), msg: msgError);
      CrashlyticsUtil.logError(_revoExceptions);
      throw _revoExceptions;

    }on FirebaseAuthException catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch(error.code) {
        case "account-exists-with-different-credential":
        msg = Translate.i().get.msg_error_credential_invalid;
        break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: Translate.i().get.msg_error_generic_user_login);
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      AuthCredential auth = await _loginDatasource.signInWithGoogle();
      var user = await _loginDatasource.signInWithCredential(auth);
      await _userRevo.updateDataUserFirebase(user);
      return _handlerUser(_userRevo, MethodLogin.google);

    }on FirebaseAuthException catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch(error.code) {
        case "account-exists-with-different-credential":
          msg = Translate.i().get.msg_error_credential_invalid;
          break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(error: Exception(error), msg: Translate.i().get.msg_error_generic_user_login);
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try{

      var user = await _loginDatasource.signInWithEmailAndPassword(email, password);
      await _userRevo.updateDataUserFirebase(user);
      return _handlerUser(_userRevo, MethodLogin.email);

    } on FirebaseAuthException catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch (error.code) {
        case 'invalid-email':
          msg = Translate.i().get.msg_error_email_invalid;
          break;
        case 'user-disabled':
          msg = Translate.i().get.msg_error_user_block;
          break;
        case 'user-not-found':
          msg = Translate.i().get.msg_error_user_or_password_incorrect;
          break;
        case 'wrong-password':
          msg = Translate.i().get.msg_error_user_or_password_incorrect;
          break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);

    } on PlatformException catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          msg = Translate.i().get.msg_error_email_invalid;
          break;
        case 'ERROR_USER_NOT_FOUND':
          msg = Translate.i().get.msg_error_user_or_password_incorrect;
          break;
        case 'ERROR_WRONG_PASSWORD':
          msg = Translate.i().get.msg_error_user_or_password_incorrect;
          break;
      }
      throw new RevoExceptions.msgToUser(stack: stack, error: error, msg: msg);

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: Translate.i().get.msg_error_generic_user_login);
    }
  }

  User _handlerUser(UserRevo user, String methodLogin) {
    if (user.userFirebase != null) {
      _analytics.eventLoginWithEmail(methodLogin);
      _analytics.setUserPropertiesDefault(user);
      return user.userFirebase!;
    } else {
      RevoExceptions _revoExceptions = new RevoExceptions
          .msgToUser(error: Exception("user == null"), msg: Translate
          .i()
          .get
          .msg_error_generic_user_login);
      CrashlyticsUtil.logError(_revoExceptions);
      throw _revoExceptions;
    }
  }
}
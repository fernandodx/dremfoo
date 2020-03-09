import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/resources/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_storage_service.dart';

String fireBaseUserUid;

class FirebaseService {
  final _googleSign = GoogleSignIn();
  final _fbLogin = FacebookLogin();
  final _auth = FirebaseAuth.instance;

  Future<void> sendResetPassword(BuildContext context, String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<ResponseApi> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount account = await _googleSign.signIn();
      final GoogleSignInAuthentication authentication =
      await account.authentication;

      print("Google User: ${account.email}");

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      return await _loginWithCredential(credential, context);
    } catch (error) {
      print("Login with Google error: $error");
      return ResponseApi.error(msg: error.toString());
    }
  }

  Future<ResponseApi<FirebaseUser>> _loginWithCredential(AuthCredential credential, BuildContext context) async {
     AuthResult result = await _auth.signInWithCredential(credential);
    final FirebaseUser user = await result.user;
    saveUser(context, user.displayName, user.email);
    print("Login realizado com sucesso!!!");
    print("Nome: ${user.displayName}");
    print("E-mail: ${user.email}");
    print("Foto: ${user.photoUrl}");

    return ResponseApi<FirebaseUser>.ok(result: user);
  }

  Future<ResponseApi> loginWithFacebook(BuildContext context) async {
    try{

      FacebookLoginResult result = await _fbLogin.logIn(['email', 'public_profile']);
      String msg = "";

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          return await _loginWithCredential(credential, context);
          break;

        case FacebookLoginStatus.cancelledByUser:
          msg = "Tudo bem, você pode utilizar outro método de login.";
          return ResponseApi.error(msg: msg);
          break;
        case FacebookLoginStatus.error:
          msg = result.errorMessage;
          return ResponseApi.error(msg: msg);
          break;
      }

    } catch (error) {
      print("Login with Google error: $error");
      return ResponseApi.error(msg: error.toString());
    }

  }

  Future<ResponseApi> loginWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser user = await result.user;
      print("Login realizado com sucesso!!!");
      print("Nome: ${user.displayName}");
      print("E-mail: ${user.email}");
      print("Foto: ${user.photoUrl}");
      saveUser(context, user.displayName, user.email);

      return ResponseApi<FirebaseUser>.ok(result: user);
    } catch (error) {
      String msg = "Não foi possível autenticar o seu usuário.";

      if (error is PlatformException) {
        PlatformException exception = error as PlatformException;

        switch (exception.code) {
          case 'ERROR_INVALID_EMAIL':
            msg = Strings.msgErroEmailInvalid;
            break;
          case 'ERROR_USER_NOT_FOUND':
            msg = Strings.msgErroUserNotFound;
            break;
          case 'ERROR_WRONG_PASSWORD':
            msg = Strings.msgErroPasswordWrong;
            break;
          default:
            break;
        }
        print(
            "Login with Google COD: ${exception.code} MSG: ${exception.message}");
      } else {
        print("Login with Google error: $error");
      }
      return ResponseApi<FirebaseUser>.error(msg: msg);
    }
  }

  Future<ResponseApi> updateUser(BuildContext context, {name, urlPhoto}) async {
    try {
      final updateUser = UserUpdateInfo();
      if (urlPhoto != null) {
        updateUser.photoUrl = urlPhoto;
      }
      updateUser.displayName = name ?? "";

      var user = await FirebaseAuth.instance.currentUser();
      user.updateProfile(updateUser);
      saveUser(context, user.displayName, user.email);

      return ResponseApi<FirebaseUser>.ok(result: user);
    } catch (error) {
      print("Erro ao atualizar o usuário: ${error}");
      return ResponseApi<FirebaseUser>.error(msg: error.toString());
    }
  }

  Future<ResponseApi> createUserWithEmailAndPassword(
      BuildContext context, String email, String password,
      {String name, File photo}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = await result.user;
      setUidUser(user.uid);
      saveUser(context, name, email);

      var urlPhotoUser = null;

      if (photo != null) {
        urlPhotoUser = await FirebaseStorageService()
            .uploadFileUserOn(photo, id: "user_photo");
      }

      if (name != null || urlPhotoUser != null) {
        final updateUser = UserUpdateInfo();
        updateUser.photoUrl = urlPhotoUser;
        updateUser.displayName = name ?? "";
        await user.updateProfile(updateUser);
      }

      var currentUser = await _auth.currentUser();

      return ResponseApi<FirebaseUser>.ok(result: currentUser);
    } catch (error) {
      String msg = error.toString();
      if (error is PlatformException) {
        PlatformException exception = error as PlatformException;

        switch (exception.code) {
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            msg = Strings.msgErroEmailAlReadyInUse;
            break;
        }

        print(
            "Erro ao criar o usuário: cod - ${error.code} mensagem - ${error.message}");
      }

      return ResponseApi<FirebaseUser>.error(msg: msg);
    }
  }



  void setUidUser(uid) {
    if (uid != null) {
      fireBaseUserUid = uid;
    }
  }

  void saveUser(BuildContext context, name, email) {
    if (name != null && email != null) {
      DocumentReference refUsers =
          Firestore.instance.collection("users").document(fireBaseUserUid);
      refUsers.setData({"name": name, "e-mail": email}).catchError((error) {
        print("ERRO AO SALVAR O USUARIO : $error");
      });
    }

//      MainEventBus().get(context).updateUser(user);
  }

  logout() {
    _auth.signOut();
    _googleSign.signOut();
  }
}

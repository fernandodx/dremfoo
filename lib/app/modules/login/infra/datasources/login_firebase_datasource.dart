import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/ilogin_datasource.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginFirebaseDataSource implements ILoginDatasource {

  Completer<String> _instance = Completer<String>();
  // Completer<FirebaseAuth> _auth = Completer<FirebaseAuth>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSign = GoogleSignIn();
  FacebookAuth _facebookSign = FacebookAuth.instance;

  _init() async {

    Future.delayed(Duration(seconds: 2)).then((value) {
      _instance.complete(" FirebaseDataSource Finish");
    });

  }

  LoginFirebaseDataSource(){
   _init();
  }

  Future exempleMethod() async {
    var value = await _instance.future;
  }

  @override
  Future<void> sendResetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email).catchError(_handlerError);
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return await result.user;
    } catch(error){
      throw error;
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return await result.user;
    } catch(error){
      throw error;
    }
  }

  @override
  Future<AuthCredential> signInWithGoogle() async {
    try{
      final GoogleSignInAccount? account = await _googleSign.signIn();
      final GoogleSignInAuthentication? authentication = await account?.authentication;
      return GoogleAuthProvider.credential(
          idToken: authentication?.idToken,
          accessToken: authentication?.accessToken);
    } catch(error){
      throw error;
    }
  }

  @override
  Future<User?> signInWithCredential(AuthCredential credential) async {
    try{
      UserCredential result = await _auth.signInWithCredential(credential);
      return await result.user;
    } catch(error){
      throw error;
    }
  }

  @override
  Future<LoginResult> signInWithFacebook() async {
    return  _facebookSign.login(permissions: ['email', 'public_profile']).catchError(_handlerError);
  }

  _handlerError(error, stack) {
    throw error;
  }

}
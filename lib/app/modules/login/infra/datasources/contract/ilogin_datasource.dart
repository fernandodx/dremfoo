
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract class ILoginDatasource {

  Future<void> sendResetPassword(String email);

  Future<User?> createUserWithEmailAndPassword(String email, String password);

  Future<User?> signInWithEmailAndPassword(String email, String password);

  Future<AuthCredential> signInWithGoogle();

  Future<User?> signInWithCredential(AuthCredential credential);

  Future<LoginResult> signInWithFacebook();

  Future<void> logOut();

}
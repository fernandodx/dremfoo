import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ILoginRepository {

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<void> sendResetPassword(String email);

  Future<User> signInWithFacebook();

  Future<User> signInWithGoogle();

  Future<void> logOut();

}
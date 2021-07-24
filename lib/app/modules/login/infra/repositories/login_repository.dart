import 'package:dremfoo/app/modules/login/domain/stories/login_store.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/contract/ilogin_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/firebase_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/ilogin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginRepository implements ILoginRepository {

  final ILoginDatasource _loginDatasource = Modular.get<FirebaseDataSource>();
  final LoginStore stores = Modular.get<LoginStore>();

  @override
  Future<User> login() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendResetPassword(String email) {
    _loginDatasource.sendResetPassword(email);
  }



}
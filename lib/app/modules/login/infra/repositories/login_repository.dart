import 'package:dremfoo/app/modules/login/infra/datasources/contract/ilogin_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/ilogin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository implements ILoginRepository {

  final ILoginDatasource _loginDatasource;

  LoginRepository(this._loginDatasource);

  @override
  Future<User> login() {
    throw UnimplementedError();
  }

  @override
  Future<void> sendResetPassword(String email) {
    return _loginDatasource.sendResetPassword(email);
  }



}
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/widget/alert_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'base_bloc.dart';

class LoginBloc extends BaseBloc {
  final formKey = GlobalKey<FormState>();

  User user = User();

  Future<FirebaseUser> login(BuildContext context) async {

    if (!formKey.currentState.validate()) {
      print("Erro na validação");
      return null;
    }

    showLoading();

    print("USER : ${user.email} SENHA: ${user.password}");

    formKey.currentState.save();

    ResponseApi responseApi = await FirebaseService()
        .loginWithEmailAndPassword(context, user.email, user.password);

    hideLoading();

    if (responseApi.ok) {
      FirebaseUser user = responseApi.result;
      print("LOGIN REALIZADO: ${user.email} Foto: ${user.photoUrl}");
      return user;
    } else {
      alertBottomSheet(
        context,
        msg: responseApi.msg,
        title: "Erro na Autenticação",
        tipoAlert: TipoAlert.ERROR
      );
      return null;
    }
  }
}

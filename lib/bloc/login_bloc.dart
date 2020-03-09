import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/widget/alert_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'base_bloc.dart';

class LoginBloc extends BaseBloc {
  final formKey = GlobalKey<FormState>();

  User user = User();

  var textEmailController = TextEditingController();

  Future<FirebaseUser> login(BuildContext context) async {
    if (!formKey.currentState.validate()) {
      print("Erro na validação");
      return null;
    }
    formKey.currentState.save();

    showLoading();
    ResponseApi responseApi = await FirebaseService()
        .loginWithEmailAndPassword(context, user.email, user.password);
    hideLoading();
    return checkResponseApiOnLogin(responseApi, context);
  }

  FirebaseUser checkResponseApiOnLogin(ResponseApi responseApi, BuildContext context) {
     if (responseApi.ok) {
      FirebaseUser user = responseApi.result;
      print("LOGIN REALIZADO: ${user.email} Foto: ${user.photoUrl}");
      return user;
    } else {
      alertBottomSheet(context,
          msg: responseApi.msg,
          title: "Erro na Autenticação",
          type: TypeAlert.ERROR);
      return null;
    }
  }

  rememberPassword(BuildContext context) async {
    if (textEmailController.text == null ||
        textEmailController.text.length <= 0) {
      alertBottomSheet(context,
          msg: "Preencha o e-mail para reiniciar a sua senha.",
          title: "Reset de senha",
          type: TypeAlert.ALERT);

      return;
    }

    showLoading();

    try {
      await FirebaseService()
          .sendResetPassword(context, textEmailController.text);

      hideLoading();
      alertBottomSheet(context,
          msg:
              "Um e-mail foi enviado com orientações para reiniciar a sua senha.",
          title: "Envio com sucesso",
          type: TypeAlert.SUCESS);
    } catch (error) {
      print("ERRO ENVIO DO E-MAIL : $error");
      hideLoading();
      if (error is PlatformException) {
        var msg = "";
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            msg = "E-mail não encontrado";
            break;
        }
        alertBottomSheet(context,
            msg: msg, title: "Erro no envio do e-mail", type: TypeAlert.ERROR);
      }
    }
  }

  loginWithGoogle(BuildContext context) async {
    showLoading();
    ResponseApi responseApi =  await FirebaseService().loginWithGoogle(context);
    hideLoading();
    return checkResponseApiOnLogin(responseApi, context);
  }

  Future<FirebaseUser> loginWithFacebook(BuildContext context) async {
    showLoading();
    ResponseApi responseApi = await FirebaseService().loginWithFacebook(context);
    hideLoading();
    return checkResponseApiOnLogin(responseApi, context);
  }
}

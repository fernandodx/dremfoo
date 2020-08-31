import 'dart:async';

import 'package:date_util/date_util.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/eventbus/user_event_bus.dart';
import 'package:dremfoo/model/level_revo.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/model/user_focus.dart';
import 'package:dremfoo/utils/analytics_util.dart';
import 'package:dremfoo/widget/alert_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'base_bloc.dart';

class LoginBloc extends BaseBloc {

  final _loginIsOnStremController = StreamController<bool>();

  Stream<bool> get streamLoginOn => _loginIsOnStremController.stream;


  final formKey = GlobalKey<FormState>();

  UserRevo user = UserRevo();

  var textEmailController = TextEditingController();

  Future<User> login(BuildContext context) async {
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

  User checkResponseApiOnLogin(ResponseApi responseApi, BuildContext context) {
     if (responseApi.ok) {
      User user = responseApi.result;
      print("LOGIN REALIZADO: ${user.email} Foto: ${user.photoURL}");
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
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.forgotPassword, parameters: {"user": textEmailController.text});
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

  Future<User> loginWithFacebook(BuildContext context) async {
    showLoading();
    ResponseApi responseApi = await FirebaseService().loginWithFacebook(context);
    hideLoading();
    return checkResponseApiOnLogin(responseApi, context);
  }

  @override
  dispose() {
    super.dispose();
    _loginIsOnStremController.close();
  }





}

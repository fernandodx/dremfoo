import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/login/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/contract/ilogin_repository.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/analytics_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'contract/ilogin_case.dart';

class LoginUseCase implements ILoginCase {

  ILoginRepository _loginRepository;
  LoginUseCase(this._loginRepository);

  @override
  Future<User> login(BuildContext context) async {
    return _loginRepository.login();
  }

  @override
  Future<void> sendResetPassword(String email) async {
    return _loginRepository.sendResetPassword(email);
  }

  @override
  Future<ResponseApi> rememberPassword(String email) async {
    if (email == null || email.length <= 0) {
      return ResponseApi.error(messageAlert: MessageAlert.create("Reset de senha", "Preencha o e-mail para reiniciar a sua senha.", TypeAlert.ALERT));
    }
    if (!email.contains("@") || !email.contains(".com")) {
      return ResponseApi.error(messageAlert: MessageAlert.create("Reset de senha", "E-mail inválido.", TypeAlert.ALERT));
    }

    try {
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.forgotPassword, parameters: {"user": email});
      await sendResetPassword(email);
      return ResponseApi.ok(messageAlert: MessageAlert.create("Envio com sucesso",  "Um e-mail foi enviado com orientações para reiniciar a sua senha.", TypeAlert.SUCESS));
    } catch (error) {
      print("ERRO ENVIO DO E-MAIL : $error");
      if (error is PlatformException) {
        var msg = "";
        switch (error.code) {
          case "ERROR_USER_NOT_FOUND":
            msg = "E-mail não encontrado";
            break;
        }
        return ResponseApi.error(messageAlert: MessageAlert.create("Erro no envio do e-mail", msg, TypeAlert.ERROR));
      }
      return ResponseApi.error(messageAlert: MessageAlert.create("Erro no envio do e-mail", error.toString(), TypeAlert.ERROR));
    }
  }



}
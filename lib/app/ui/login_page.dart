import 'dart:io';

import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/api/bloc/login_bloc.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/resources/strings.dart';
import 'package:dremfoo/app/ui/register_page.dart';
import 'package:dremfoo/app/utils/analytics_util.dart';
import 'package:dremfoo/app/utils/nav.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:dremfoo/app/utils/validator_util.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = LoginBloc();
  Widget pageInit;

  @override
  void initState() {
    super.initState();

    pageInit = Container(
       decoration: AppColors.backgroundBoxDecoration(),
      child: Center(
        child: TextUtil.textDefault("Carregando..."),
      ),
    );

    FirebaseService().checkLoginOn().then((isLoginOk) {
      if (isLoginOk) {
        AnalyticsUtil.sendLogLogin(MethodLogin.sharedPrefs);
        push(context, HomePage(), isReplace: true);
      } else {
        setState(() {
          pageInit = SingleChildScrollView(
            child: body(context),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryDark,
      body: Form(
        key: _bloc.formKey,
        child: Stack(
          children: <Widget>[
            background(),
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: Image.asset(
                Utils.getPathAssetsImg(
                  "logo_background.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            pageInit,
            _bloc.loading(),
          ],
        ),
      ),
    );
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              Utils.getPathAssetsImg("logo.png"),
              width: 140,
              height: 140,
            ),
          ],
        ),
        containerBody(context),
      ],
    );
  }

  Container containerBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 16),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 10.0,
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getFields(context),
          ),
        ),
      ),
    );
  }

  List<Widget> getFields(BuildContext context) {
    return <Widget>[
      TextUtil.textTitulo("Login"),
      SizedBox(height: 16),
      AppTextDefault(
        validator: ValidatorUtil.validatorEmail,
        inputType: TextInputType.emailAddress,
        icon: Icons.email,
        inputAction: TextInputAction.next,
        onSaved: (value) => _bloc.user.email = value,
        controller: _bloc.textEmailController,
        maxLength: 60,
        name: "E-mail",
      ),
      SizedBox(height: 16),
      AppTextDefault(
        validator: ValidatorUtil.validatorPassword,
        inputAction: TextInputAction.done,
        maxLength: 12,
        icon: Icons.lock,
        isPassword: true,
        inputType: TextInputType.text,
        onSaved: (value) => _bloc.user.password = value,
        name: "Senha",
      ),
      SizedBox(height: 16),
      Container(
        child: AppButtonDefault(
          label: "Entrar",
          mainAxisSize: MainAxisSize.max,
          onPressed: () => onClickLogin(context),
        ),
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppButtonDefault(
              decoration: TextDecoration.underline,
              label: Strings.labelNotRegister,
              type: TypeButton.FLAT,
              onPressed: () => push(context, RegisterPage())),
          AppButtonDefault(
              decoration: TextDecoration.underline,
              label: Strings.labelRemenberPassword,
              type: TypeButton.FLAT,
              onPressed: () => _bloc.rememberPassword(context)),
        ],
      ),
      Row(
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minWidth: 300,
                maxHeight: 2,
              ),
              color: AppColors.colorPrimary,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            "OU",
            style: TextStyle(
                color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minWidth: 300,
                maxHeight: 2,
              ),
              color: AppColors.colorPrimary,
            ),
          )
        ],
      ),
      SizedBox(height: 16),
      Row(
        children: <Widget>[
          Expanded(
            child: SignInButton(
              buttonType: ButtonType.google,
              onPressed: () => onClickLoginWithGoogle(context),
              btnText: "Login com Google",
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Visibility(
        visible: Platform.isIOS,
        child: Row(
          children: <Widget>[

            Expanded(
              child: SignInButton(
                buttonType: ButtonType.facebook,
                onPressed: () => onClickLoginWithFacebook(context),
                btnText: "Login com Facebook",
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void onClickLogin(BuildContext context) {
    _bloc.login(context).then((user) {
      goToHome(user, context);
    });
  }

  void onClickLoginWithFacebook(BuildContext context) {
    _bloc.loginWithFacebook(context).then((user) {
      goToHome(user, context);
    });
  }

  void onClickLoginWithGoogle(BuildContext context) {
    _bloc.loginWithGoogle(context).then((user) {
      goToHome(user, context);
    });
  }

  void goToHome(user, BuildContext context) {
    if (user != null) {
      push(context, HomePage(), isReplace: true);
    }
  }

  Container background() {
    return Container(
      decoration: AppColors.backgroundBoxDecoration(),
    );
  }
}

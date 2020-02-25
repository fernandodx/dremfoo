import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/bloc/login_bloc.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/resources/strings.dart';
import 'package:dremfoo/ui/register_page.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/validator_util.dart';
import 'package:dremfoo/widget/app_button_default.dart';
import 'package:dremfoo/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = LoginBloc();

  @override
  void initState() {
    super.initState();

    List<Widget> listBody = [];

    listBody.add(body(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _bloc.formKey,
        child: Stack(
          children: <Widget>[
            background(),
            body(context),
            _bloc.loading(),
          ],
        ),
      ),
    );
  }

  Column body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        containerLogo(),
        containerBody(context),
      ],
    );
  }

  Container containerBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      constraints: BoxConstraints(minWidth: 500.0, minHeight: 300.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 10.0,
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
        name: "E-mail",
      ),
      SizedBox(height: 16),
      AppTextDefault(
        validator: ValidatorUtil.validatorPassword,
        inputAction: TextInputAction.done,
        icon: Icons.lock,
        isPassword: true,
        inputType: TextInputType.text,
        onSaved: (value) => _bloc.user.password = value,
        name: "Senha",
      ),
      SizedBox(height: 16),
      Row(
        children: <Widget>[
          Expanded(
            child: AppButtonDefault(
              label: "Entrar",
              onPressed: () => onClickLogin(context),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      AppButtonDefault(
          decoration: TextDecoration.underline,
          label: Strings.labelNotRegister,
          type: TypeButton.FLAT,
          onPressed: () => push(context, RegisterPage())),
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
            child: GoogleSignInButton(
              onPressed: () => print(""),
              borderRadius: 8.0,
              text: "Login com Google",
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Row(
        children: <Widget>[
          Expanded(
            child: FacebookSignInButton(
              onPressed: () => print(""),
              borderRadius: 8.0,
              text: "Login com Facebook",
            ),
          ),
        ],
      ),
    ];
  }

  containerLogo() {
    return Column(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          child: Image.asset("assets/images/logoSomnia.png"),
        ),
        TextUtil.textTitulo("Dremfo", color: Colors.white)
      ],
    );
  }

  void onClickLogin(BuildContext context) {
    _bloc.login(context).then((user) {
      if(user != null){
        push(context, HomePage());
      }
    });
  }

  Container background() {
    return Container(
      decoration: AppColors.backgroundBoxDecoration(),
    );
  }
}

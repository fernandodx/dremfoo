import 'dart:io';

import 'package:dremfoo/app/modules/login/domain/stories/login_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/resources/strings.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/validator_util.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class CardLoginWidget extends StatelessWidget {

  Function onClickLogin;
  Function onClickLoginWithGoogle;
  Function onClickLoginWithFacebook;

  CardLoginWidget(this.onClickLogin, this.onClickLoginWithGoogle, this.onClickLoginWithFacebook);

  final LoginStore _store = Modular.get<LoginStore>();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 10.0,
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: getFields(context),
        ),
      ),
    );
  }

  List<Widget> getFields(BuildContext context) {
    return <Widget>[
      TextUtil.textTitulo(Translate.i().get.label_login),
      SizedBox(height: 16),
      AppTextDefault(
        validator: ValidatorUtil.validatorEmail,
        inputType: TextInputType.emailAddress,
        icon: Icons.email,
        inputAction: TextInputAction.next,
        onSaved: (value) => _store.user.email = value,
        controller: _store.textEmailController,
        maxLength: 60,
        name: Translate.i().get.label_email,
      ),
      SizedBox(height: 16),
      AppTextDefault(
        validator: ValidatorUtil.validatorPassword,
        inputAction: TextInputAction.done,
        maxLength: 12,
        icon: Icons.lock,
        isPassword: true,
        inputType: TextInputType.text,
        onSaved: (value) => _store.user.password = value,
        name: Translate.i().get.label_password,
      ),
      SizedBox(height: 16),
      Container(
        child: AppButtonDefault(
          label: Translate.i().get.label_enter,
          mainAxisSize: MainAxisSize.max,
          onPressed: () => onClickLogin(),
        ),
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppButtonDefault(
              decoration: TextDecoration.underline,
              label: Translate.i().get.label_not_rigister,
              type: TypeButton.FLAT,
              onPressed: () {
                //push(context, RegisterPage())
              }),
          AppButtonDefault(
              decoration: TextDecoration.underline,
              label: Translate.i().get.label_forgot_password,
              type: TypeButton.FLAT,
              onPressed: () => _store.rememberPassword(context)),
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
            Translate.i().get.label_or,
            style: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
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
              onPressed: () => onClickLoginWithGoogle(),
              btnText: Translate.i().get.label_login_with_google,
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
                onPressed: () => onClickLoginWithFacebook(),
                btnText: Translate.i().get.label_login_with_facebook,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
import 'dart:io';

import 'package:dremfoo/app/modules/core/ui/widgets/line_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/login/domain/stories/login_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/validator_util.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class CardLoginWidget extends StatelessWidget {

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
      SpaceWidget(),
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
      SpaceWidget(),
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
      SpaceWidget(),
      Container(
        child: AppButtonDefault(
          label: Translate.i().get.label_enter,
          mainAxisSize: MainAxisSize.max,
          onPressed: () => _store.onLoginWithEmail(context)
        ),
      ),
      SpaceWidget(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppButtonDefault(
              decoration: TextDecoration.underline,
              label: Translate.i().get.label_not_rigister,
              type: TypeButton.FLAT,
              onPressed: () => _store.onNotRegister(),
              ),
          AppButtonDefault(
              decoration: TextDecoration.underline,
              label: Translate.i().get.label_forgot_password,
              type: TypeButton.FLAT,
              onPressed: () => _store.rememberPassword(context)),
        ],
      ),
      Row(
        children: <Widget>[
          LineWidget(
            color: AppColors.colorPrimary,
          ),
          SpaceWidget(
            isSpaceRow: true,
          ),
          Text(
            Translate.i().get.label_or,
            style: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold),
          ),
          SpaceWidget(
            isSpaceRow: true,
          ),
          LineWidget(
            color: AppColors.colorPrimary,
          ),
        ],
      ),
      SpaceWidget(),
      Row(
        children: <Widget>[
          Expanded(
            child: SignInButton(
              buttonType: ButtonType.google,
              onPressed: () => _store.onLoginWithGoogle(context),
              btnText: Translate.i().get.label_login_with_google,
              padding: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Row(
        children: <Widget>[
          Expanded(
            child: SignInButton(
              buttonType: ButtonType.facebook,
              btnColor: AppColors.colorBlizzardBlueDark,
              onPressed: () => _store.onLoginWithFacebook(context),
              btnText: Translate.i().get.label_login_with_facebook,
              padding: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
        ],
      ),
    ];
  }
}

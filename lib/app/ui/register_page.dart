
import 'package:dremfoo/app/api/bloc/register_bloc.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/resources/strings.dart';
import 'package:dremfoo/app/utils/nav.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:dremfoo/app/utils/validator_util.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  final _bloc = RegisterBloc();

  @override
  void initState() {
    super.initState();

    _bloc.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: Utils.isCenterTitleAppBar(),
        title: TextUtil.textAppbar(Strings.titleRegisterEmail),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
              ),
              onPressed: () => registerUserOnPress(context),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              headerRegister(),
              Expanded(
                child: Form(
                  key: _bloc.formKey,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        gradient: AppColors.backgroundPageGradient()),
                    child: ListView(
                      children: <Widget>[
                        AppTextDefault(
                          name: "Nome",
                          maxLength: 40,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.text,
                          onSaved: (name) => _bloc.user.name = name,
                          validator: ValidatorUtil.requiredField,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AppTextDefault(
                          name: "E-mail",
                          maxLength: 50,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.emailAddress,
                          onSaved: (email) => _bloc.user.email = email,
                          validator: ValidatorUtil.validatorEmail,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AppTextDefault(
                          name: "Confirme o e-mail",
                          maxLength: 50,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.emailAddress,
                          validator: ValidatorUtil.validatorEmail,
                          controller: _bloc.validatedEmailController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AppTextDefault(
                          name: "Senha",
                          maxLength: 12,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          onSaved: (password) => _bloc.user.password = password,
                          validator: ValidatorUtil.validatorPassword,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          _bloc.loading(),
        ],
      ),
    );
  }



  Future registerUserOnPress(BuildContext context) async {
     User? user = await _bloc.resgisterUser(context);
     if(user != null){
       push(context, HomePage(), isReplace: true);
     }
  }

  Container headerRegister() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.colorPrimary, AppColors.colorPrimaryDark],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.elliptical(300, 160),
                  bottomStart: Radius.elliptical(300, 160)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 23),
                decoration: BoxDecoration(
                  color: Colors.white, // border color
                  shape: BoxShape.circle,
                ),
                width: 100,
                height: 100,
                child: createStreamBuilderPhotoUser(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  StreamBuilder<Widget> createStreamBuilderPhotoUser() {
    return StreamBuilder<Widget>(
      stream: _bloc.stream,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          return InkWell(
            child: snapshot.data,
            onTap: () => _bloc.onAddImage(),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

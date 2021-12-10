
import 'package:dremfoo/app/modules/core/ui/widgets/background_form_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/stories/register_user_store.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:dremfoo/app/utils/validator_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class RegisterPage extends StatefulWidget {

  final UserRevo? userRevo;
  RegisterPage({this.userRevo});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ModularState<RegisterPage, RegisterUserStore> {


  @override
  void initState() {
    super.initState();

    var overlayLoading = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black38,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    });

    reaction<bool>((_) => store.isLoading, (isLoading) {
      if(isLoading){
        Overlay.of(context)!.insert(overlayLoading);
      }else{
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if(msgErro != null){
        alertBottomSheet(context,
            msg: msgErro.msg,
            title:msgErro.title,
            type: msgErro.type);
      }
    });

   store.featch(widget.userRevo);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: Utils.isCenterTitleAppBar(),
        title: TextUtil.textAppbar(Translate.i().get.title_register_email),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.check,
              ),
              onPressed: () => store.confirmUser(context),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              headerRegister(),
              body()
            ],
          ),
          Visibility(
            visible: false,
            child: Container(
              child: Center(child: CircularProgressIndicator(),),
            ),
          ),
        ],
      ),
    );
  }

  Expanded body() {
    return Expanded(
              child: Form(
                key: store.formKey,
                child: Observer(
                  builder: (context) => ListView(
                    children: <Widget>[
                      AppTextDefault(
                        name: Translate.i().get.label_name,
                        maxLength: 40,
                        controller: store.nameTextEditingController,
                        inputAction: TextInputAction.next,
                        inputType: TextInputType.text,
                        onSaved: (name) => store.user.name = name,
                        validator: ValidatorUtil.requiredField,
                      ),
                      SpaceWidget(),
                      AppTextDefault(
                        name: Translate.i().get.label_email,
                        maxLength: 50,
                        inputAction: TextInputAction.next,
                        controller: store.emailTextEditingController,
                        inputType: TextInputType.emailAddress,
                        onSaved: (email) => store.user.email = email,
                        validator: ValidatorUtil.validatorEmail,
                      ),
                      SpaceWidget(),
                      Visibility(
                        visible: !store.isEdited,
                        child: AppTextDefault(
                          name: Translate.i().get.label_confirm_email,
                          maxLength: 50,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.emailAddress,
                          validator: ValidatorUtil.validatorEmail,
                          controller: store.validatedEmailController,
                        ),
                      ),
                      SpaceWidget(),
                      Visibility(
                        visible: !store.isEdited,
                        child: AppTextDefault(
                          name: Translate.i().get.label_password,
                          maxLength: 12,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.visiblePassword,
                          isPassword: true,
                          onSaved: (password) => store.user.password = password,
                          validator: ValidatorUtil.validatorPassword,
                        ),
                      ),
                      SpaceWidget(),
                    ],
                  ),
                ),
              ),
            );
  }


  Container headerRegister() {
    return Container(
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
                  bottomStart: Radius.elliptical(300, 160),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 23),
                decoration: BoxDecoration(
                  color: AppColors.colorlight, // border color
                  shape: BoxShape.circle,
                ),
                width: 100,
                height: 100,
                child: InkWell(
                  child: Observer(
                    builder: (_) {
                      if(store.containerImage == null){
                        return getContainerChoiceImage();
                      }
                      return store.containerImage!;
                    },
                  ),
                  onTap: () => store.onAddImage(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container getContainerChoiceImage() {
    var containerImage = Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(Utils.getPathAssetsImg("icon_user.png"),
            fit: BoxFit.contain,
            height: 40,
            width: 40,
            color: AppColors.colorPrimaryDark,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(Utils.getPathAssetsImg("icon_edit.png"),
                fit: BoxFit.contain,
                height: 20,
                width: 20,
                color: AppColors.colorPrimaryDark,
              ),
            ],
          ),
        ],
      ),
    );
    return containerImage;
  }
}

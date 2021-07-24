import 'package:dremfoo/app/modules/login/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/login/domain/stories/login_store.dart';
import 'package:dremfoo/app/modules/login/ui/widgets/background_widget.dart';
import 'package:dremfoo/app/modules/login/ui/widgets/card_login_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class LoginWidgetPage extends StatefulWidget {
  final String title;

  const LoginWidgetPage({Key key, this.title = 'LoginWidgetPage'}) : super(key: key);

  @override
  LoginWidgetPageState createState() => LoginWidgetPageState();
}

class LoginWidgetPageState extends ModularState<LoginWidgetPage, LoginStore> {
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
        Overlay.of(context).insert(overlayLoading);
      }else{
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert>((_) => store.msgAlert, (msgErro) {
      alertBottomSheet(context,
          msg: msgErro.msg,
          title:msgErro.title,
          type: msgErro.type);
    });

    reaction((_) => store.navigation, (pageRoute) {
      Modular.to.navigate(pageRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorPrimaryDark,
      body: Form(
        key: store.formKey,
        child: Stack(
          children: <Widget>[
            BackgroundWidget(),
            SingleChildScrollView(
              child: body(context),
            ),
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
      child: CardLoginWidget(
        () => store.login(context),
        () => store.loginWithFacebook(context),
        () => store.loginWithGoogle(context),
      ),
    );
  }
}

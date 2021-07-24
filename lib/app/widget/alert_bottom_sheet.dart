import 'package:dremfoo/app/modules/login/domain/entities/type_alert.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

alertBottomSheet(BuildContext context,
    {@required String msg,
    TypeAlert type = TypeAlert.ALERT,
    Function onTapDefaultButton,
    String nameButtonDefault = "OK",
    String title = "Alerta",
    String subTitle,
    List<Widget> listButtonsAddtional,
    bool isWillPop = true}) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => isWillPop,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 40,
                      color: AppColors.colorAcent,
                      padding: EdgeInsets.only(left: 8),
                      child: subTitle != null
                          ? titleWithSubtitleWidget(title, subTitle)
                          : titleWidget(title),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.white,
                            child: Text(
                              msg,
                              style: TextStyle(
                                  color: AppColors.colorPrimaryDark,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBarTheme(
                      data: ButtonBarThemeData(
                          buttonPadding: EdgeInsets.all(8),
                          buttonTextTheme: ButtonTextTheme.accent),
                      child: Container(
                        color: Colors.white,
                        child: ButtonBar(
                          children: buttonsAlert(context, nameButtonDefault,
                              onTapDefaultButton, listButtonsAddtional),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    child: animationFlareForType(type),
                  ),
                ],
              )
            ],
          ),
        );
      });
}

List<Widget> buttonsAlert(BuildContext context, String nameDefaultButton,
    Function onTapDefaultButton, List<Widget> listButtonsAdtional) {
  List<Widget> listButtons = [];

  listButtons.add(
    FlatButton(
      child: Text(nameDefaultButton),
      onPressed: () {
        Navigator.pop(context);
        if (onTapDefaultButton != null) {
          onTapDefaultButton();
        }
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );

  if (listButtonsAdtional != null) {
    listButtons.addAll(listButtonsAdtional);
  }

  return listButtons;
}

titleWithSubtitleWidget(String titulo, String subTitulo) {
  return Row(
    children: <Widget>[
      Column(
        children: <Widget>[
          Text(
            titulo,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Text(
            subTitulo,
            style: TextStyle(color: Colors.white70),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    ],
    mainAxisSize: MainAxisSize.max,
  );
}

titleWidget(String titulo) {
  return Row(
    children: <Widget>[
      Column(
        children: <Widget>[
          Text(
            titulo,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    ],
    mainAxisSize: MainAxisSize.max,
  );
}

animationFlareForType(TypeAlert tipoAlert) {
  switch (tipoAlert) {
    case TypeAlert.SUCESS:
      return animationflareSucess();

    case TypeAlert.ERROR:
      return animationflareError();

    default:
      return animationflareAlert();
  }
}

animationflareError() {
  return FlareActor(
    "assets/animations/error.flr",
    shouldClip: true,
    animation: "Error",
  );
}

animationflareSucess() {
  return FlareActor(
    "assets/animations/success_check.flr",
    shouldClip: true,
    animation: "show",
  );
}

animationflareAlert() {
  return Container(
    padding: EdgeInsets.all(20),
    child: FlareActor(
      "assets/animations/bell.flr",
      shouldClip: true,
      animation: "Notification Loop",
    ),
  );
}

Container bodyAredondado(BuildContext context) {
  return Container(
    height: 250.0,
    color: Colors.transparent,
    child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0))),
        child: new Center(
          child: FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        )),
  );
}

Container body(BuildContext context) {
  return Container(
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              color: AppColors.colorPrimaryDark,
              child: animationflareError(),
            ),
            Expanded(
              child: Container(
                height: 50,
                color: AppColors.colorPrimaryDark,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Alerta",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 100,
          color: Colors.white,
        ),
        ButtonBarTheme(
          data: ButtonBarThemeData(
            buttonMinWidth: 50,
          ),
          child: ButtonBar(
            buttonPadding: EdgeInsets.all(16),
            children: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              FlatButton(
                child: Text('CANCELAR'),
                onPressed: () => Navigator.pop(context),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



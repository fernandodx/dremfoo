import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

simpleAlert(
  BuildContext context, {
  @required String msg,
  Function onPressOk,
  String title = "Alerta",
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPressOk();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      });
}

import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:flutter/material.dart';

class ButtonBarStepperWidget extends StatelessWidget {

  final Function()? onStepContinue;
  final Function()? onStepCancel;
  final bool isLastStep;

  ButtonBarStepperWidget({this.onStepContinue, this.onStepCancel, required this.isLastStep});

  @override
  Widget build(BuildContext context) {

    String labelContinue = isLastStep ? Translate.i().get.label_finish : Translate.i().get.label_next;

    return ButtonBarTheme(
      data: ButtonBarThemeData(
          buttonPadding: EdgeInsets.all(6),
          buttonTextTheme: ButtonTextTheme.accent),
      child: Container(
        child: ButtonBar(
          children: [
            ElevatedButton(
              onPressed: onStepContinue,
              child: Text(
                labelContinue,
              ),
            ),
            TextButton(
              onPressed: onStepCancel,
              child: Text(
                Translate.i().get.label_previous,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
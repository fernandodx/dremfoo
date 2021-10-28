import 'package:dremfoo/app/modules/dreams/ui/widgets/button_bar_stepper_widget.dart';
import 'package:flutter/material.dart';

class StepperRegisterDreamWidget extends StatelessWidget {

  final List<Step> listStep;
  final int currentStep;
  final Function()? onStepContinue;
  final Function()? onStepCancel;
  final Function(int)? onStepTapped;

  StepperRegisterDreamWidget(
      {
        required this.listStep,
        required this.currentStep,
        this.onStepContinue,
        this.onStepCancel,
        this.onStepTapped
      });

  @override
  Widget build(BuildContext context) {
    return Stepper(
      steps: listStep,
      currentStep: currentStep,
      onStepContinue: onStepContinue,
      onStepCancel: onStepCancel,
      onStepTapped: onStepTapped,
      controlsBuilder: (BuildContext context,
          {VoidCallback? onStepContinue,
            VoidCallback? onStepCancel}) {
        return ButtonBarStepperWidget(
            isLastStep: false,
            onStepCancel: onStepCancel,
          onStepContinue: onStepContinue,
        );
      },
    );
  }
}
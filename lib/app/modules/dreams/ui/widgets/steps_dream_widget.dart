import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/choice_chip_revo_widget.dart';
import 'package:flutter/material.dart';

class StepsDreamWidget extends StatelessWidget {
  List<StepDream>? listStepDream;
  String colorSteps;
  Function(bool isSelected, StepDream stepSelected) onTap;

  StepsDreamWidget(
      {required this.listStepDream,
        required this.colorSteps,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (listStepDream == null || listStepDream!.isEmpty) {
      list.add(Center(child: LinearProgressIndicator(),));
    }else{
      listStepDream!.forEach((step) {
        list.add(ChoiceChipRevoWidget(
            label: step.step ?? "",
            color: colorSteps,
            isCompleted: step.isCompleted ?? false,
            onSelected: (isSelected) {
              onTap(isSelected, step);
            }));
      });
    }

    return Wrap(
      children: list,
    );
  }
}

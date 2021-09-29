import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/choice_chip_revo_widget.dart';
import 'package:flutter/material.dart';

class DailyGoalsDreamWidget extends StatelessWidget {

  List<DailyGoal>? listDailyGoal;
  String colorGoal;
  Function(bool isSelected, DailyGoal stepSelected) onTap;

  DailyGoalsDreamWidget({required this.listDailyGoal, required this.colorGoal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (listDailyGoal == null || listDailyGoal!.isEmpty) {
      list.add(Center(child: LinearProgressIndicator(),));
    }else{
      listDailyGoal!.forEach((dailyGoal) {
        list.add(ChoiceChipRevoWidget(
            label: dailyGoal.nameDailyGoal ?? "",
            color: colorGoal,
            isCompleted: dailyGoal.isCompletedToday(),
            onSelected: (isSelected) {
              onTap(isSelected, dailyGoal);
            }));
      });

    }



    return Wrap(
      children: list,
    );
  }
}

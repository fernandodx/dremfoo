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
      listDailyGoal = [];
      for (var i = 0; i <= 5; i++) {
        var d = DailyGoal();
        d.nameDailyGoal = "Loading - $i";
        d.lastDateCompleted = Timestamp.now();

        listDailyGoal!.add(d);
      }
    }

    listDailyGoal!.forEach((dailyGoal) {
      // Utils.colorFromHex(daily.dreamParent.color!.primary!)
      list.add(ChoiceChipRevoWidget(
          label: dailyGoal.nameDailyGoal ?? "",
          color: colorGoal,
          isCompleted: dailyGoal.isCompletedToday(),
          onSelected: (isSelected) {
            onTap(isSelected, dailyGoal);
          }));
    });

    return Wrap(
      children: list,
    );
  }
}

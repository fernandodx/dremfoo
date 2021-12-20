import 'package:dremfoo/app/model/daily_goal.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/header_item_dream_widget.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class ListDreamWidget extends StatelessWidget {
  final List<Dream> listDream;
  final AnimationController controller;
  final Function(Dream) onTapDetailDream;
  final Function(Dream) onTapCreateFocusDream;
  final bool isLoadingStepDaily;

  ListDreamWidget({
    required this.listDream,
    required this.controller,
    required this.onTapDetailDream,
    required this.onTapCreateFocusDream,
    required this.isLoadingStepDaily,
  });

  createListView() {
    List<Widget> children = [];

    listDream.forEach((dream) {

      var countDaily = 0;
      var countStep = 0;
      var countDailyToday = 0;
      var countStepCompleted = 0;
      double? percent = null;
      double? percentStep = null;


      if(dream.dailyGoals != null) {
        countDaily = dream.dailyGoals!.length;
      }

      if(dream.steps != null){
        countStep = dream.steps!.length;
        countStepCompleted = dream.steps!
            .where((step) => step.isCompleted??false).toList().length;

        percentStep = 0;

        if(countStepCompleted > 0 && countStep > 0){
          percentStep = countStepCompleted / countStep;
        }
      }

      if(dream.listHistoryWeekDailyGoals != null && dream.listHistoryWeekDailyGoals!.length > 0){
        countDailyToday = dream.listHistoryWeekDailyGoals!
            .where((daily) => daily.lastDateCompleted!.toDate().isSameDate(DateTime.now()))
            .toList().length;

        percent = 0;

        if(countDailyToday > 0 && countDaily > 0) {
          percent = countDailyToday / countDaily;
        }
      }

      children.add(Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderItemDreamWidget(
              isLoading: isLoadingStepDaily,
              percentStep: percentStep?.toIntPercent??"0%",
              percentToday: percent?.toIntPercent??"0%",
              valueToday: percent,
              valueStep: percentStep,
              imageBase64: dream.imgDream,
              onTapImage: () {
                onTapDetailDream(dream);
              },
              isDreamAwait: dream.isDreamWait??false,
              onTapCreateFocus: () {
                onTapCreateFocusDream(dream);
              },
            ),
            SizedBox(height: 8,),
            TextUtil.textSubTitle(dream.dreamPropose ?? "", fontSize: 12, fontWeight: FontWeight.bold),
            TextUtil.textDefault(dream.descriptionPropose ??"", fontSize: 12),
            SpaceWidget(),
            SpaceWidget(),
          ],
        ),
      ));
    });

    return ListView(
    children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return createListView();
  }
}

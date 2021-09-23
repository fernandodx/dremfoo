import 'package:dremfoo/app/modules/core/ui/widgets/button_outlined_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/daily_goals_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/steps_dream_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class BodyItemDreamWidget extends StatelessWidget {
  final bool isVisible;
  final String colorDream;
  final Dream dream;
  final List<StepDream>? listStepDream;
  final List<DailyGoal>? listDailyGoal;
  final Function(bool isSelected, DailyGoal dailyGoalSelected) onTapDailyGoal;
  final Function(bool isSelected, StepDream stepSelected) onTapStep;
  final Function() onTapHist;

  BodyItemDreamWidget(
      {required this.isVisible,
      required this.colorDream,
      required this.dream,
      required this.onTapDailyGoal,
      required this.onTapStep,
      required this.onTapHist,
      this.listStepDream,
      this.listDailyGoal});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          !isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 500),
      firstChild: Container(
        width: double.maxFinite,
        height: 0,
      ),
      secondChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TextUtil.textTitulo(Translate.i().get.label_steps),
              SpaceWidget(
                isSpaceRow: true,
              ),
            ],
          ),
          SpaceWidget(),
          StepsDreamWidget(
            listStepDream: listStepDream,
            colorSteps: colorDream,
            onTap: onTapStep,
          ), //
          SpaceWidget(),
          SpaceWidget(),
          TextUtil.textTitulo(Translate.i().get.label_daily_goals),
          SpaceWidget(),
          DailyGoalsDreamWidget(
              listDailyGoal: listDailyGoal,
              colorGoal: colorDream,
              onTap: onTapDailyGoal),
          SpaceWidget(),
          Container(
            alignment: Alignment.center,
            child: ButtonOutlinedRevoWidget(
                icon: Icons.calendar_today_outlined,
                label: Translate.i().get.label_hist_daily_goal,
                onTap: onTapHist),
          ),
          SpaceWidget(),
        ],
      ),
    );
  }
}

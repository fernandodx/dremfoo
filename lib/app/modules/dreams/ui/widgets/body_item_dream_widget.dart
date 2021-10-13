
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/chart_week_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/daily_goals_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/dual_buttons_option_selected_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/steps_dream_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class BodyItemDreamWidget extends StatelessWidget {
  final String colorDream;
  final List<StepDream>? listStepDream;
  final List<DailyGoal>? listDailyGoal;
  final List<DailyGoal>? listHistWeekDailyGoal;
  final List<DailyGoal>? listHistMonthDailyGoal;
  final Function(bool isSelected, DailyGoal dailyGoalSelected) onTapDailyGoal;
  final Function(bool isSelected, StepDream stepSelected) onTapStep;
  final Function(bool isWeekChart) onTapSelectChart;
  final bool isChartWeek;
  final double goalWeek;
  final double goalMonth;

  BodyItemDreamWidget(
      {required this.colorDream,
    required this.onTapDailyGoal,
    required this.onTapStep,
    required this.onTapSelectChart,
    required this.isChartWeek,
    this.listStepDream,
    this.listDailyGoal,
    this.listHistWeekDailyGoal,
        this.listHistMonthDailyGoal,
        this.goalWeek = 0,
        this.goalMonth = 0,});

  //TODO criar body caso seja um sonho em espera


  @override
  Widget build(BuildContext context) {

    if(listStepDream == null || listStepDream!.isEmpty){
      return getBodyDreamAwait();
    }else{
      return getBodyDreamWithFocus();
    }
  }
  
  Widget getBodyDreamAwait() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextUtil.textTitulo("Sonho em espera!"),
          SpaceWidget(),
          Icon(Icons.access_time, size: 50, color: AppColors.colorlight,),
          SpaceWidget(),
          ElevatedButton(onPressed: (){}, child: Text("Tonar sonho com foco"))
        ],
      ),
    );
  }
  
  Widget getBodyDreamWithFocus() {

    bool isChartVisible = true;

    if(isChartWeek && (listHistWeekDailyGoal == null || listHistWeekDailyGoal!.isEmpty)){
      isChartVisible = false;
    }
    if(!isChartWeek && (listHistMonthDailyGoal == null || listHistMonthDailyGoal!.isEmpty)){
      isChartVisible = false;
    }
    
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
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
          SpaceWidget(),
          Visibility(
            visible: isChartVisible,
            child: DualButtonsOptionSelectedWidget(
              titleLeft: Translate.i().get.label_weekly,
              titleRight: Translate.i().get.label_monthly,
              isLeftSelect: isChartWeek,
              onPressLeft: () =>  onTapSelectChart(true),
              onPressRight: () =>  onTapSelectChart(false),
            ),
          ),
          Visibility(
            visible: isChartVisible,
            child: ChartWeekWidget(
              listHistWeekDailyGoal: listHistWeekDailyGoal,
              listHistMonthDailyGoal: listHistMonthDailyGoal,
              isChartWeek: isChartWeek,
              goalMonth: goalMonth,
              goalWeek: goalWeek,
            ),
          ),
          SpaceWidget(),
        ],
      ),
    );
  }

}

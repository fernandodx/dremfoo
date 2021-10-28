import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentStepGoalDailyWidget extends StatelessWidget {

  final Widget expansionInfo;
  final List<Widget> listDailyGoals;
  final TextEditingController dailyGoalTextEditController;
  final Function(String nameStep, int position) onAddDailyGoal;

  ContentStepGoalDailyWidget({
    required this.expansionInfo,
    required this.listDailyGoals,
    required this.dailyGoalTextEditController,
    required this.onAddDailyGoal});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          expansionInfo,
          SpaceWidget(),
          Column(
            children: getWidgetsDailyGoals(),
          ),
        ],
      ),
    );
  }

  List<Widget> getWidgetsDailyGoals() {
    if (listDailyGoals.isEmpty) {
      return getDefaultDailyGoal();
    }
    List<Widget> dailyGoalWithOptions = getDefaultDailyGoal();
    dailyGoalWithOptions.addAll(listDailyGoals);
    return dailyGoalWithOptions;
  }

  List<Widget> getDefaultDailyGoal() {
    return [
      AppTextDefault(
        name: Translate.i().get.label_daily_goal,
        maxLength: 25,
        icon: FontAwesomeIcons.bullseye,
        inputAction: TextInputAction.done,
        controller: dailyGoalTextEditController,
        onFieldSubmitted: (value) {
          var position = listDailyGoals.length + 1;
          onAddDailyGoal(value, position);
        }
      ),
      Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        child: AppButtonDefault(
          onPressed: () {
            var position = listDailyGoals.length + 1;
            onAddDailyGoal(dailyGoalTextEditController.value.text, position);
          },
          icon: Icon(Icons.add_circle),
          label: Translate.i().get.label_add,
        ),
      )
    ];
  }
}
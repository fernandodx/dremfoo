import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentStepGoalDreamWidget extends StatelessWidget {

  final Widget expansionInfo;
  final List<Widget> listStepsForWin;
  final TextEditingController stepTextEditController;
  final Function(String nameStep, int position) onAddStepForWin;

  ContentStepGoalDreamWidget({
    required this.expansionInfo,
    required this.listStepsForWin,
    required this.stepTextEditController,
    required this.onAddStepForWin});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          expansionInfo,
          SpaceWidget(),
          Column(
            children: getStepForWin(),
          ),
        ],
      ),
    );
  }

  List<Widget> getStepForWin() {
    if (listStepsForWin.isEmpty) {
      return getDefaultStepForWin();
    }
    List<Widget> stepWithOptions = getDefaultStepForWin();
    stepWithOptions.addAll(listStepsForWin);
    return stepWithOptions;
  }

  List<Widget> getDefaultStepForWin() {
    return [
      AppTextDefault(
        name: Translate.i().get.label_step,
        maxLength: 25,
        icon: FontAwesomeIcons.shoePrints,
        inputAction: TextInputAction.done,
        controller: stepTextEditController,
        onFieldSubmitted: (value) {
          var position = listStepsForWin.length + 1;
          onAddStepForWin(value, position);
        }
      ),
      Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        child: AppButtonDefault(
          onPressed: () {
            var position = listStepsForWin.length + 1;
             onAddStepForWin(stepTextEditController.value.text, position);
          },
          icon: Icon(Icons.add_circle),
          label: Translate.i().get.label_add,
        ),
      ),
    ];
  }
}
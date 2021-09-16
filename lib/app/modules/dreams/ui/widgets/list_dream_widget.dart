import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/header_item_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/panel_info_dream_expansion_header_widget.dart';
import 'package:flutter/material.dart';

import 'body_item_dream_widget.dart';

class ListDreamWidget extends StatelessWidget {

  final List<Dream> listDream;
  final AnimationController controller;
  final Function(bool isSelected, DailyGoal dailyGoal) onTapDailyGoal;
  final Function(bool isSelected, StepDream step) onTapStep;
  final Function() onTapHist;
  final Function(bool, Dream) onTapExpansionPanel;
  final Function(Dream) onTapConfigDream;
  final Map<Dream, bool> isVisibleBodyDreamMap;

  ListDreamWidget({required this.listDream, required this.controller, required this.onTapDailyGoal,
    required this.onTapStep,required this.onTapExpansionPanel, required this.onTapHist, required this.isVisibleBodyDreamMap,
    required this.onTapConfigDream});


  createListView(){
    List<Widget> children = [];

    listDream.forEach((dream) {

      bool isInitBodyVisible = isVisibleBodyDreamMap[dream]??false;

      children.add(
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderItemDreamWidget(
                  percentStep: "40%",
                  percentToday: "10%",
                  valueToday: 0.1,
                  valueStep: 0.4,
                  urlImage: dream.imgDream??"https://www.criandocomapego.com/wp-content/uploads/2018/03/manual-dos-sonhos.jpg",
                  onTapImage: () {
                    onTapConfigDream(dream);
                  },
                ),
                SpaceWidget(),
                PanelInfoDreamExpansionHeaderWidget(
                  title: dream.dreamPropose??"Meu Sonho",
                  subTitle: dream.descriptionPropose??"Descrição",
                  controller: controller,
                  onTap: () {
                    onTapExpansionPanel(true, dream);
                  },
                ),
                SpaceWidget(),
                SpaceWidget(),
                BodyItemDreamWidget(
                    isVisible: isInitBodyVisible,
                    colorDream: dream.color?.primary??"#BAF3BE",
                    dream: dream,
                    onTapDailyGoal: onTapDailyGoal,
                    onTapStep: onTapStep,
                    onTapHist: onTapHist),
              ],
            ),
          )
      );
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
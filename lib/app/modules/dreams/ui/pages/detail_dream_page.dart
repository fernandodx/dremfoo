import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/body_item_dream_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DetailDreamPage extends StatefulWidget {

  @override
  DetailDreamPageState createState() => DetailDreamPageState();
}

class DetailDreamPageState extends ModularState<DetailDreamPage, DetailDreamStore> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Hero(
            tag: "imgDream",
            child: Utils.string64ToImage(store.dream.imgDream!,
                width: double.maxFinite, fit: BoxFit.cover),
          ),
          SpaceWidget(),
          BodyItemDreamWidget(
              colorDream: store.dream.color?.primary ?? "#BAF3BE",
              onTapDailyGoal: (bool isSelected, DailyGoal dailyGoal) {
                print("$isSelected ${dailyGoal.toString()}");
              },
              onTapStep: (bool isSelected, StepDream step) {
                print("$isSelected ${step.toString()}");
              },
              onTapHist: (){
                print("Hitorico");
              },
          ),

        ],
      ),
    );
  }
}

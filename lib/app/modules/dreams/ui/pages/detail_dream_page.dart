import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/body_item_dream_widget.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailDreamPage extends StatefulWidget {

  final Dream dreamSelected;
  DetailDreamPage(this.dreamSelected);

  @override
  DetailDreamPageState createState() => DetailDreamPageState();
}

class DetailDreamPageState extends ModularState<DetailDreamPage, DetailDreamStore> {

  @override
  void initState() {
    super.initState();

    var overlayLoading = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black38,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    });

    reaction<bool>((_) => store.isLoading, (isLoading) {
      if(isLoading){
        Overlay.of(context)!.insert(overlayLoading);
      }else{
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if(msgErro != null){
        alertBottomSheet(context,
            msg: msgErro.msg,
            title:msgErro.title,
            type: msgErro.type);
      }
    });

    store.fetch(widget.dreamSelected);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Utils.string64ToImage(widget.dreamSelected.imgDream??"",
              width: double.maxFinite, fit: BoxFit.cover),
          SpaceWidget(),
          Observer(
            builder: (context) {
              return BodyItemDreamWidget(
                listDailyGoal: store.listDailyGoals,
                listStepDream: store.listStep,
                colorDream: widget.dreamSelected.color?.primary ?? "#BAF3BE",
                onTapDailyGoal: (bool isSelected, DailyGoal dailyGoal) {
                  store.updateDailyGoal(dailyGoal, isSelected);
                },
                onTapStep: (bool isSelected, StepDream step) {
                  store.updateStepDream(step, isSelected);
                },
                onTapHist: (){
                  print("Hitorico");
                },
              );
            },
          ),

        ],
      ),
    );
  }
}

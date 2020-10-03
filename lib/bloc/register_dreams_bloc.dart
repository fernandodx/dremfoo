import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/base_bloc.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/model/daily_goal.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/step_dream.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/analytics_util.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/alert_bottom_sheet.dart';
import 'package:dremfoo/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class RegisterDreamsBloc extends BaseBloc {
  Dream dream;
  Dream dreamForEdit;
  List<int> stepErrors = [];
  int currentStep = 0;
  bool complete = false;
  List<Step> steps = [];
  List<Widget> stepsForWin = [];
  List<Widget> dailyGoals = [];
  TextEditingController stepTextEditController = TextEditingController();
  TextEditingController dailyGoalTextEditController = TextEditingController();
  TextEditingController dreamTextEditController = TextEditingController();
  TextEditingController dreamDescriptionTextEditController =
      TextEditingController();
  TextEditingController rewardTextEditController = TextEditingController();
  TextEditingController rewardWeekTextEditController = TextEditingController();
  TextEditingController inflectionTextEditController = TextEditingController();
  TextEditingController inflectionWeekTextEditController =
      TextEditingController();
  List<bool> listInfoExpanted = [];


  void fetch(context, dreamEdit, isWait) {
    if (dreamEdit == null) {
      dream = Dream();
      dream.isDreamWait = isWait;
      dream.steps = [];
      steps = [];
    } else {
      dream = Dream.copy(dreamEdit);
      dreamForEdit = Dream.copy(dreamEdit);
      dreamTextEditController.text = dream.dreamPropose;
      initStepForWin(dream, context);
      initDailyGoals(dream, context);
      rewardTextEditController.text = dream.reward;
      inflectionTextEditController.text = dream.inflection;
      dreamDescriptionTextEditController.text = dream.descriptionPropose;
      inflectionWeekTextEditController.text = dream.inflectionWeek;
      rewardWeekTextEditController.text = dream.rewardWeek;
    }

  }

  @override
  dispose(){
    super.dispose();
  }

  deleteDream(context) {
    showLoading();
    ResponseApi<bool> responseApi = FirebaseService().deleteDream(dreamForEdit);
    if (responseApi.ok) {
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.dreamDeleted);
      hideLoading();
      alertBottomSheet(context,
          msg:
              "Seu sonho foi arquivado com sucesso, não se preocupe, você pode reverter isso quando achar necessário",
          type: TypeAlert.SUCESS, onTapDefaultButton: () {
        MainEventBus().get(context).sendEventHomeDream(TipoEvento.FETCH);
        pop(context, "");
      });
    }
  }

 Widget getImageDream() {
    if(dream.imgDream != null && dream.imgDream.isNotEmpty){
     return  Utils.string64ToImage(dream.imgDream, fit: BoxFit.cover);
    }else{
      return Image.asset(Utils.getPathAssetsImg("icon_gallery_add.png"), width: 100, height: 100,scale: 5,);
    }
  }

  setDataDream() {
    dream.dreamPropose = dreamTextEditController.text.toString();
    dream.reward = rewardTextEditController.text.toString();
    dream.inflection = rewardTextEditController.text.toString();
  }

  validDataStream() {
    if (dream.imgDream != null || dream.imgDream.isEmpty) {}
  }

  void initStepForWin(Dream dream, context) {
    var inputText = AppTextDefault(
        name: "Passo",
        maxLength: 25,
        icon: Icons.queue,
        inputAction: TextInputAction.done,
        controller: stepTextEditController,
        onFieldSubmitted: (value) =>
            addStepForWin(value, stepsForWin.length, context));

    stepsForWin.add(inputText);

    dream.steps.forEach((step) {
      var newChip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorChipSecundary,
          child: TextUtil.textChip('${step.position}˚', maxLines: 1),
        ),
        label: TextUtil.textChip('${step.step}˚', maxLines: 1),
        backgroundColor: AppColors.colorChipPrimary,
        onDeleted: () => removeStepForWin(step.position, context),
        deleteIconColor: Colors.white,
      );

      stepTextEditController.clear();
      stepsForWin.add(newChip);
//      onRefresh();
    });
  }

  void initDailyGoals(Dream dream, context) {
    var inputText = AppTextDefault(
        name: "Meta diária",
        maxLength: 25,
        icon: Icons.queue,
        inputAction: TextInputAction.done,
        controller: dailyGoalTextEditController,
        onFieldSubmitted: (value) =>
            addDailyGoals(value, dailyGoals.length, context));

    dailyGoals.add(inputText);

    dream.dailyGoals.forEach((daily) {
      var newChip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorChipSecundary,
          child: TextUtil.textChip('${daily.position}˚', maxLines: 1),
        ),
        label: TextUtil.textChip('${daily.nameDailyGoal}˚', maxLines: 1),
        backgroundColor: AppColors.colorChipPrimary,
        onDeleted: () => removeDailyGoals(daily.position, context),
        deleteIconColor: Colors.white,
      );

      dailyGoalTextEditController.clear();
      dailyGoals.add(newChip);
    });
  }

  removeStepForWin(position, context) {
    stepsForWin.removeAt(position);
    List<Widget> stepTmp = List.of(stepsForWin);

    stepsForWin.clear();
    dream.steps.clear();
    stepsForWin.add(stepTmp[0]);
    stepsForWin.add(stepTmp[1]);

    for (var position = 2; position < stepTmp.length; position++) {
      Chip chip = stepTmp[position];
      Text text = chip.label;
      addStepForWinOnly(text.data, position, context);
    }
//    onRefresh();
    MainEventBus().get(context).sendEventRegisterDreamApp(TipoEvento.REFRESH);
  }

  removeDailyGoals(position, context) {
    dailyGoals.removeAt(position);
    List<Widget> dailyTmp = List.of(dailyGoals);

    dailyGoals.clear();
    dream.dailyGoals.clear();
    dailyGoals.add(dailyTmp[0]);
    dailyGoals.add(dailyTmp[1]);

    for (var position = 2; position < dailyTmp.length; position++) {
      Chip chip = dailyTmp[position];
      Text text = chip.label;
      addDailyGoalOnly(text.data, position, context);
    }
//    onRefresh();
    MainEventBus().get(context).sendEventRegisterDreamApp(TipoEvento.REFRESH);
  }

  List<Widget> addStepForWinOnly(nameStep, position, context) {
    var newChip = Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorChipSecundary,
        child: TextUtil.textChip('${position}˚', maxLines: 1),
      ),
      label: TextUtil.textChip(nameStep, maxLines: 1),
      backgroundColor: AppColors.colorChipPrimary,
      onDeleted: () => removeStepForWin(position, context),
      deleteIconColor: Colors.white,
    );

    StepDream sd = StepDream();
    sd.step = nameStep;
    sd.position = position;
    dream.steps.add(sd);

    stepsForWin.add(newChip);
  }

  List<Widget> addDailyGoalOnly(nameStep, position, context) {
    var newChip = Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorChipSecundary,
        child:TextUtil.textChip('${position}˚', maxLines: 1),
      ),
      label: TextUtil.textChip(nameStep, maxLines: 1),
      backgroundColor: AppColors.colorChipPrimary,
      onDeleted: () => removeDailyGoals(position, context),
      deleteIconColor: Colors.white,
    );

    DailyGoal dg = DailyGoal();
    dg.nameDailyGoal = nameStep;
    dg.position = position;
    dream.dailyGoals.add(dg);

    dailyGoals.add(newChip);
  }

  void addStepForWin(String nameStep, position, context) {
    if(nameStep == null || nameStep.isEmpty){
      return;
    }

    var newChip = Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorChipSecundary,
        child: TextUtil.textChip('${position}˚', maxLines: 1),
      ),
      label: TextUtil.textChip(nameStep, maxLines: 1),
      backgroundColor: AppColors.colorChipPrimary,
      onDeleted: () => removeStepForWin(position, context),
      deleteIconColor: Colors.white,
    );

    StepDream sd = StepDream();
    sd.step = nameStep;
    sd.position = position;
    dream.steps.add(sd);

    stepTextEditController.clear();
    stepsForWin.add(newChip);
    AnalyticsUtil.sendAnalyticsEvent(EventRevo.addStepforDream);

//    onRefresh();
    MainEventBus().get(context).sendEventRegisterDreamApp(TipoEvento.REFRESH);
  }

  void addDailyGoals(nameGoal, position, context) {
    var newChip = Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorChipSecundary,
        child: TextUtil.textChip('${position}˚', maxLines: 1)
      ),
      label: TextUtil.textChip('${nameGoal}˚', maxLines: 1),
      backgroundColor: AppColors.colorChipPrimary,
      onDeleted: () => removeDailyGoals(position, context),
      deleteIconColor: Colors.white,
    );

    DailyGoal dg = DailyGoal();
    dg.nameDailyGoal = nameGoal;
    dg.position = position;
    dream.dailyGoals.add(dg);

    dailyGoalTextEditController.clear();
    dailyGoals.add(newChip);
    AnalyticsUtil.sendAnalyticsEvent(EventRevo.addDailyForDream);

//    onRefresh();
    MainEventBus().get(context).sendEventRegisterDreamApp(TipoEvento.REFRESH);
  }

  void dreamCompleted() {
    FirebaseService().updateOnlyField("dateFinish", Timestamp.now(), dream.reference);
  }


}

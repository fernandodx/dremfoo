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

  final _addimgDreamController = StreamController<Widget>();

  Stream<Widget> get streamImgDream => _addimgDreamController.stream;

  void fetch(dreamEdit, context) {
    if (dreamEdit == null) {
      dream = Dream();
      final imgDefault =
          Image.asset(Utils.getPathAssetsImg("icon_gallery_add.png"));
//    await Future.delayed(Duration(seconds: 4));
      dream.steps = [];
      steps = [];
      _addimgDreamController.add(imgDefault);
    } else {
      dream = Dream.copy(dreamEdit);
      dreamForEdit = Dream.copy(dreamEdit);
      dreamTextEditController.text = dream.dreamPropose;
      _addimgDreamController.add(Utils.string64ToImage(dream.imgDream));
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
    _addimgDreamController.close();
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

  addImage(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File compressedImg = await FlutterNativeImage.compressImage(image.path,
        quality: 80, targetWidth: 600, targetHeight: 500);

    List<int> imageBytes = compressedImg.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    dream.imgDream = base64Image;

//    var imgBytes = base64Decode(base64Image);

    if (image != null) {
      _addimgDreamController.add(Image.file(image));
//      _addimgDreamController.add(Image.memory(imgBytes));
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.addImageDream);
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
          backgroundColor: AppColors.colorPrimary,
          child: TextUtil.textDefault('${step.position}˚', color: Colors.white, maxLines: 1),
        ),
        label: TextUtil.textDefault('${step.step}˚', color: Colors.white, maxLines: 1),
        backgroundColor: AppColors.colorAcent,
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
          backgroundColor: AppColors.colorPrimary,
          child: TextUtil.textDefault('${daily.position}˚', color: Colors.white, maxLines: 1),
        ),
        label: TextUtil.textDefault('${daily.nameDailyGoal}˚', color: Colors.white, maxLines: 1),
        backgroundColor: AppColors.colorAcent,
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

    for (var position = 1; position < stepTmp.length; position++) {
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

    for (var position = 1; position < dailyTmp.length; position++) {
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
        backgroundColor: AppColors.colorPrimary,
        child: TextUtil.textDefault('${position}˚', color: Colors.white, maxLines: 1),
      ),
      label: TextUtil.textDefault(nameStep, color: Colors.white, maxLines: 1),
      backgroundColor: AppColors.colorAcent,
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
        backgroundColor: AppColors.colorPrimary,
        child:TextUtil.textDefault('${position}˚', color: Colors.white, maxLines: 1),
      ),
      label: TextUtil.textDefault(nameStep, color: Colors.white, maxLines: 1),
      backgroundColor: AppColors.colorAcent,
      onDeleted: () => removeDailyGoals(position, context),
      deleteIconColor: Colors.white,
    );

    DailyGoal dg = DailyGoal();
    dg.nameDailyGoal = nameStep;
    dg.position = position;
    dream.dailyGoals.add(dg);

    dailyGoals.add(newChip);
  }

  void addStepForWin(nameStep, position, context) {
    var newChip = Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorPrimary,
        child: TextUtil.textDefault('${position}˚', color: Colors.white, maxLines: 1),
      ),
      label: TextUtil.textDefault(nameStep, color: Colors.white, maxLines: 1),
      backgroundColor: AppColors.colorAcent,
      onDeleted: () => removeStepForWin(position, context),
      deleteIconColor: Colors.white,
    );

    StepDream sd = StepDream();
    sd.step = nameStep;
    sd.position = position;
    print(dream.steps);
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
        backgroundColor: AppColors.colorPrimary,
        child: TextUtil.textDefault('${position}˚', color: Colors.white, maxLines: 1)
      ),
      label: TextUtil.textDefault('${nameGoal}˚', color: Colors.white, maxLines: 1),
      backgroundColor: AppColors.colorAcent,
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

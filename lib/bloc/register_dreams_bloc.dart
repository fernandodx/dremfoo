import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dremfoo/bloc/base_bloc.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/model/daily_goal.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/step_dream.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/utils.dart';
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
  TextEditingController rewardTextEditController = TextEditingController();
  TextEditingController rewardWeekTextEditController = TextEditingController();
  TextEditingController inflectionTextEditController = TextEditingController();
  TextEditingController inflectionWeekTextEditController = TextEditingController();

  final _addimgDreamController = StreamController<Widget>();

  Stream<Widget> get streamImgDream => _addimgDreamController.stream;

  void fetch(dreamEdit, context)  {
    if (dreamEdit == null) {
      dream = Dream();
      final imgDefault = Image.asset(Utils.getPathAssetsImg("icon_gallery_add.png"));
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
    }
  }


  addImage(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File compressedImg = await FlutterNativeImage.compressImage(
        image.path, quality: 80, targetWidth: 600, targetHeight: 500);

    List<int> imageBytes = compressedImg.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    dream.imgDream = base64Image;

    var imgBytes = base64Decode(base64Image);

    if (image != null) {
//      _addimgDreamController.add(Image.file(image));
      _addimgDreamController.add(Image.memory(imgBytes));
    }
  }

  setDataDream() {
    dream.dreamPropose = dreamTextEditController.text.toString();
    dream.reward = rewardTextEditController.text.toString();
    dream.inflection = rewardTextEditController.text.toString();
  }

  validDataStream() {
    if (dream.imgDream != null || dream.imgDream.isEmpty) {

    }
  }

  void initStepForWin(Dream dream, context) {
    var inputText = AppTextDefault(
        name: "Passo",
        icon: Icons.queue,
        inputAction: TextInputAction.done,
        controller: stepTextEditController,
        onFieldSubmitted: (value) => addStepForWin(value, stepsForWin.length, context));

    stepsForWin.add(inputText);

    dream.steps.forEach((step) {
      var newChip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorPrimary,
          child: Text(
            '${step.position}˚',
            style: TextStyle(color: Colors.white),
          ),
        ),
        label: Text(
          step.step,
          style: TextStyle(color: Colors.white),
        ),
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
        icon: Icons.queue,
        inputAction: TextInputAction.done,
        controller: dailyGoalTextEditController,
        onFieldSubmitted: (value) => addDailyGoals(value, dailyGoals.length, context));

    dailyGoals.add(inputText);

    dream.dailyGoals.forEach((daily) {
      var newChip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorPrimary,
          child: Text(
            '${daily.position}˚',
            style: TextStyle(color: Colors.white),
          ),
        ),
        label: Text(
          daily.nameDailyGoal,
          style: TextStyle(color: Colors.white),
        ),
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
    MainEventBus().get(context).sendEventUpdateRegisterApp(false);
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
    MainEventBus().get(context).sendEventUpdateRegisterApp(false);
  }


  List<Widget> addStepForWinOnly(nameStep, position, context) {
    var newChip = Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorPrimary,
        child: Text(
          '${position}˚',
          style: TextStyle(color: Colors.white),
        ),
      ),
      label: Text(
        nameStep,
        style: TextStyle(color: Colors.white),
      ),
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
        child: Text(
          '${position}˚',
          style: TextStyle(color: Colors.white),
        ),
      ),
      label: Text(
        nameStep,
        style: TextStyle(color: Colors.white),
      ),
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
        child: Text(
          '${position}˚',
          style: TextStyle(color: Colors.white),
        ),
      ),
      label: Text(
        nameStep,
        style: TextStyle(color: Colors.white),
      ),
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

//    onRefresh();
  MainEventBus().get(context).sendEventUpdateRegisterApp(false);
  }

  void addDailyGoals(nameGoal, position, context) {
    var newChip = Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorPrimary,
        child: Text(
          '${position}˚',
          style: TextStyle(color: Colors.white),
        ),
      ),
      label: Text(
        nameGoal,
        style: TextStyle(color: Colors.white),
      ),
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

//    onRefresh();
    MainEventBus().get(context).sendEventUpdateRegisterApp(false);
  }


}
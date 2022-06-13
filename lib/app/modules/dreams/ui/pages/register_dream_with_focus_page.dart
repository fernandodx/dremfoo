
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/button_appbar_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/dream_page_dto.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/register_dream_with_focus_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_alarm_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_goal_daily_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_goal_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_inflection_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_info_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_reward_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_settings_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/expasion_panel_list_info_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/stepper_register_dream_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/ui/register_dreams_page.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/nav.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:dremfoo/app/widget/search_picture_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class RegisterDreamWithFocusPage extends StatefulWidget {
  DreamPageDto dreamPageDto;
  RegisterDreamWithFocusPage(this.dreamPageDto);

  @override
  RegisterDreamWithFocusPageState createState() => RegisterDreamWithFocusPageState();
}
class RegisterDreamWithFocusPageState extends ModularState<RegisterDreamWithFocusPage, RegisterDreamWithFocusStore> {

  @override
  void initState() {
    super.initState();

    StepsEnum.values.forEach((element) {
      store.listInfoExpanted.add(false);
    });

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

    store.fetch(context, widget.dreamPageDto.dream, widget.dreamPageDto.isDreamWait);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.i().get.label_dream),
        actions: [
          Visibility(
            visible: widget.dreamPageDto.isDreamWait,
            child: ButtonAppbarWidget(
              labelButton: Translate.i().get.label_file_dream,
              onTapButton: () {
                store.archiveDream(context, widget.dreamPageDto.dream!);
              },
            ),
          ),
        ],
      ),
      body: bodyRegisterDreamPage(),
    );
  }

  Container bodyRegisterDreamPage() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: Observer(
                builder: (context) => StepperRegisterDreamWidget(
                  listStep: getSteps(),
                  currentStep: store.currentStep,
                  onStepContinue: () => store.nextStep(context),
                  onStepCancel: () => store.cancelStep(),
                  onStepTapped: (step) => store.goToStep(step),
                  isLastStep: store.isLastStepCurrent,
          ),
              )),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    if(widget.dreamPageDto.isDreamWait){
      store.steps = [
        stepInfoDream(),
        stepConfigDream(),
      ];
    }else{
      store.steps = [
        stepInfoDream(),
        stepGoalDream(),
        stepGoalDaily(),
        stepRewardDream(),
        stepInflectionDream(),
        stepAlarmDream(),
        stepConfigDream(),
      ];
    }
    return store.steps;
  }

  Step stepConfigDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.CONFIG),
      state: store.getStateStep(StepsEnum.CONFIG),
      title: TextUtil.textTitulo(Translate.i().get.label_settings),
      content: Observer(
        builder: (context) => ContentStepSettingsDreamWidget(
          expansionInfo: expansionPanelListInfo(StepsEnum.CONFIG.index, Translate.i().get.msg_info_settings_dream),
          dream: store.dream,
          isWait: widget.dreamPageDto.isDreamWait,
          listColorDream: store.listColorDream,
          onChangeColorDream: (ColorDream colorDream) {
            store.changeColorDream(colorDream);
          },
          onChangeValueGoalMonth: (valueGoalMonth) {
            store.changeGoalMonthDream(valueGoalMonth);
          },
          onChangeValueGoalWeek: (valueGoalWeek) {
            store.changeGoalWeekDream(valueGoalWeek);
          },
        ),
      ),
    );
  }

  Step stepAlarmDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.ALARM),
      state: store.getStateStep(StepsEnum.ALARM),
      title: TextUtil.textTitulo(Translate.i().get.label_step_alarm),
      content: Observer(
        builder: (context) => ContentStepAlarmDreamWidget(
          expansionInfo: expansionPanelListInfo(StepsEnum.ALARM.index, Translate.i().get.label_step_alarm),
          alarmDream: store.dream.alarm,
          onTimeSelected: (timeOfDay) {
            store.updateTimeAlarm(timeOfDay);
          },
          onChangeEnableNotification: (isEnable) {
            store.updateEnableNotification(isEnable);
          }, onChangeWeekDayEnable: (weekDay , isEnable ) {
            store.updateEnableWeekDayAlarm(weekDay, isEnable);
        },
        ),
      ),
    );
  }

  Step stepInflectionDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.INFLECTION),
      state: store.getStateStep(StepsEnum.INFLECTION),
      title: TextUtil.textTitulo(Translate.i().get.label_inflection_point),
      content: Observer(
        builder: (context) => ContentStepInflectionDreamWidget(
            expansionInfo: expansionPanelListInfo(StepsEnum.INFLECTION.index, Translate.i().get.msg_info_step_inflection),
            isInflectionWeek: store.dream.isInflectionWeek??false,
            inflectionTextEditController: store.inflectionTextEditController,
            inflectionWeekTextEditController: store.inflectionWeekTextEditController,
            onChangeSwitchInflectionWeek: (isChangeInflectionWeek) {
              store.changeIsInflectionWeekDream(isChangeInflectionWeek);
            },
        ),
      ),
    );
  }

  Step stepRewardDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.REWARD),
      state: store.getStateStep(StepsEnum.REWARD),
      title: TextUtil.textTitulo(Translate.i().get.label_reward),
      content: Observer(
        builder: (context) => ContentStepRewardDreamWidget(
          isRewardWeek: store.dream.isRewardWeek??false,
          rewardTextEditController: store.rewardTextEditController,
          rewardWeekTextEditController: store.rewardWeekTextEditController,
          expansionInfo: expansionPanelListInfo(StepsEnum.REWARD.index,Translate.i().get.msg_info_step_reward),
          onChangeSwitchRewardWeek: (onChangeValue) {
            store.changeIsRewardWeekDream(onChangeValue);
          },
        ),
      )
    );
  }

  Widget expansionPanelListInfo(int indexList, String subtitle) {
    return ExpasionPanelListInfoWidget(
        subtitle: subtitle,
        isExpanded: store.listInfoExpanted[indexList],
        expansionCallback: (index, isExpansive) {
            var listInfo = store.listInfoExpanted;
            listInfo[indexList] = isExpansive ? false : true;
            store.setListInfoExpanted(listInfo);
            },
        onTap: () {
           var listInfo = store.listInfoExpanted;
           var isExpandedChange = listInfo[indexList] ? false : true;
           listInfo[indexList] = isExpandedChange;
           store.setListInfoExpanted(listInfo);
        },
    );
  }

  Step stepGoalDaily() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.DAILY_GOALS),
      state: store.getStateStep(StepsEnum.DAILY_GOALS),
      title: TextUtil.textTitulo(
        Translate.i().get.label_daily_goals,
      ),
      content: Observer(
          builder: (context) {
            print("stepGoalDaily -> ${store.listDailyGoals.length}");
            return ContentStepGoalDailyWidget(
                expansionInfo:  expansionPanelListInfo(StepsEnum.DAILY_GOALS.index,
                    Translate.i().get.msg_info_step_daily_goal),
                listDailyGoals: store.listDailyGoals,
                dailyGoalTextEditController: store.dailyGoalTextEditController,
                onAddDailyGoal: (String value, int position) {
                  store.addDailyGoals(value, position);
                });
          }
      ),
    );
  }

  Step stepGoalDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.STEPS),
      state: store.getStateStep(StepsEnum.STEPS),
      title: TextUtil.textTitulo(Translate.i().get.label_step_to_conquer),
      content: Observer(
        builder: (context) {
          print("stepGoalDream -> ${store.listStepsForWin.length}");
          return ContentStepGoalDreamWidget(
              expansionInfo: expansionPanelListInfo(StepsEnum.STEPS.index, Translate.i().get.msg_info_step_conquer),
              listStepsForWin: store.listStepsForWin,
              stepTextEditController: store.stepTextEditController,
              onAddStepForWin: (String value, int position) {
                store.addStepForWin(value, position);
              });
        }
      ),
    );
  }

  Step stepInfoDream() {
    return Step(
        isActive: store.checkStepActive(StepsEnum.DREAM),
        state: store.getStateStep(StepsEnum.DREAM),
        title: TextUtil.textTitulo(Translate.i().get.label_whats_your_dream),
        content: Observer(
          builder: (BuildContext context) {
            return  ContentStepInfoDreamWidget(
              imageDreamBase64: store.dream.imgDream,
              dreamDescriptionTextEditController: store.dreamDescriptionTextEditController,
              dreamTextEditController: store.dreamTextEditController,
              onTapOpenGallery: () {
                store.loadImageGallery(context);
              },
              onTapSearchOnInternet: () {
                SearchPictureInternet search = store.searchImageInternet(context);
                push(context, search);
              },
            );
          },
        ),
    );
  }
}
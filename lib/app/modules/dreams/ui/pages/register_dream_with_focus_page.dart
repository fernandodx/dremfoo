
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/register_dream_with_focus_store.dart';
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
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:dremfoo/app/widget/search_picture_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterDreamWithFocusPage extends StatefulWidget {
  bool isWait;


  RegisterDreamWithFocusPage(this.isWait);

  @override
  RegisterDreamWithFocusPageState createState() => RegisterDreamWithFocusPageState();
}
class RegisterDreamWithFocusPageState extends ModularState<RegisterDreamWithFocusPage, RegisterDreamWithFocusStore> {

  @override
  void initState() {
    super.initState();

    store.fetch(context, null, widget.isWait);

    // MainEventBus().get(context).streamRegisterDream.listen((TipoEvento tipo) {
    //   switch (tipo) {
    //     case TipoEvento.FETCH:
    //       _bloc.fetch(context, widget.dream, widget.isWait);
    //       break;
    //     case TipoEvento.REFRESH:
    //       refresh();
    //       break;
    //   }
    // });

    StepsEnum.values.forEach((element) {
      store.listInfoExpanted.add(false);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RegisterDreamWithFocusPage f"),
      ),
      body: bodyRegisterDreamPage(),
    );
  }

  next() {
    store.currentStep + 1 != store.steps.length
        ? goTo(store.currentStep + 1)
        : finishRegisterDream();
  }

  cancel() {
    if (store.currentStep > 0) {
      goTo(store.currentStep - 1);
    }
  }

  goTo(numberStep) {
    setState(() {
      store.currentStep = numberStep;
    });
  }

  finishRegisterDream() {
    // setDataDream();
    // _bloc.showLoading();

    // if (validDataStream()) {
    //   if (_bloc.dream!.reference != null) {
    //     FirebaseService().updateDream(context, _bloc.dream!).then((response) {
    //       _bloc.hideLoading();
    //       if (response.ok) {
    //         AnalyticsUtil.sendAnalyticsEvent(EventRevo.newDream);
    //         push(context, HomePage(), isReplace: true);
    //       }
    //     });
    //   } else {
    //     FirebaseService().saveDream(context, _bloc.dream!).then((response) {
    //       _bloc.hideLoading();
    //       if (response.ok) {
    //         push(context, HomePage(), isReplace: true);
    //       }
    //     });
    //   }
    // }
  }


  Container bodyRegisterDreamPage() {
    return Container(
      color: AppColors.colorCard,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: StepperRegisterDreamWidget(
            listStep: getSteps(),
            currentStep: store.currentStep,
            onStepContinue: next,
            onStepCancel: cancel,
            onStepTapped: (step) => goTo(step),
          )),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    // if (_bloc.dream!.isDreamWait!) {
    //   _bloc.steps = [
    //     stepInfoDream(),
    //     stepConfigDream(),
    //   ];
    // } else {
    //   _bloc.steps = [
    //     stepInfoDream(),
    //     stepGoalDream(),
    //     stepGoalDaily(),
    //     stepRewardDream(),
    //     stepInflectionDream(),
    //     stepConfigDream(),
    //   ];
    return [
      stepInfoDream(),
      stepGoalDream(),
      stepGoalDaily(),
      stepRewardDream(),
      stepInflectionDream(),
      stepConfigDream(),
    ];
  }



  //TODO FAzer consulta e montar o widget
  // Container(
  //   width: MediaQuery.of(context).size.width,
  //   height: 100,
  //   child: FutureBuilder(
  //       future: FirebaseService().findAllColorsDream(),
  //       builder: (BuildContext context, AsyncSnapshot<ResponseApi<List<ColorDream>>> snapshot) {
  //         if (snapshot.hasData) {
  //           ResponseApi<List<ColorDream>> responseApi = snapshot.data!;
  //           if (responseApi.ok) {
  //             return getListviewColors(responseApi.result!);
  //           }
  //         }
  //
  //         return _bloc.getSimpleLoadingWidget(size: 100);
  //       }),
  // ),

  Step stepConfigDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.CONFIG),
      state: store.getStateStep(StepsEnum.CONFIG),
      title: TextUtil.textTituloStep(Translate.i().get.label_settings),
      content: Observer(
        builder: (context) => ContentStepSettingsDreamWidget(
          expansionInfo: expansionPanelListInfo(StepsEnum.CONFIG.index, Translate.i().get.msg_info_settings_dream),
          dream: store.dream,
          isWait: false,
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

  Step stepInflectionDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.INFLECTION),
      state: store.getStateStep(StepsEnum.INFLECTION),
      title: TextUtil.textTituloStep(Translate.i().get.label_inflection_point),
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
      title: TextUtil.textTituloStep(Translate.i().get.label_reward),
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



  void updateDreamWaitForGoal(bool value) {
    // _bloc.dream!.isDreamWait = value;
    // _bloc.showLoading();
    //
    // if(_bloc.dream!.uid == null || _bloc.dream!.uid!.isEmpty){
    //   push(context, RegisterDreamPage(), isReplace: true);
    // }else{
    //   FirebaseService().updateDream(context, _bloc.dream!).then((response) {
    //     if (response.ok) {
    //       _bloc.hideLoading();
    //       AnalyticsUtil.sendAnalyticsEvent(EventRevo.updateDreamFocus);
    //       push(context, RegisterDreamPage(dream: _bloc.dream,), isReplace: true);
    //     }
    //   });
    // }
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
      title: TextUtil.textTituloStep(
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
      title: TextUtil.textTituloStep(Translate.i().get.label_step_to_conquer),
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
        title: TextUtil.textTituloStep(Translate.i().get.label_whats_your_dream),
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
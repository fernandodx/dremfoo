
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/register_dream_with_focus_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_goal_daily_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_goal_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/content_step_info_dream_widget.dart';
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

  List<Widget> getListWidgetsConfig() {
    if (widget.isWait) {
      return listDefinitionColors();
    } else {
      List<Widget> list = listDefinitionGoal();
      list.addAll(listDefinitionColors());
      return list;
    }
  }

  String getLabelSlide(double value) {
    switch (value.toInt()) {
      case 0:
        return "Desativado";
      case 25:
        return "Iniciante";
      case 50:
        return "Moderado";
      case 75:
        return "Fora da média";
      case 100:
        return "Extraordinário";
    }
    return "Desativado";
  }

  List<Widget> listDefinitionGoal() {
    return [
      expansionPanelListInfo(StepsEnum.CONFIG.index,
          "Defina o nível que você gostaria de ser cobrado. Lembre-se de começar aos poucos, pois isso vai validar a sua performace para uma meta extraordinária."),
      SizedBox(
        height: 20,
      ),
      TextUtil.textTitulo("Meta semanal"),
      Container(
        padding: EdgeInsets.only(
          top: 50,
        ),
        child: Slider(
          value: store.dream.goalWeek!,
          onChanged: (newValue) {
            //TODO TROCAR PARA MBX
            // setState(() {
            //   store.dream!.goalWeek = newValue;
            // });
          },
          min: 25,
          max: 100,
          divisions: 3,
          activeColor: AppColors.colorPink,
          inactiveColor: AppColors.colorEggShell,
          label: getLabelSlide(store.dream.goalWeek!),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      TextUtil.textTitulo("Meta mensal"),
      Container(
        padding: EdgeInsets.only(
          top: 50,
        ),
        child: Slider(
          value: store.dream.goalMonth!,
          onChanged: (newValue) {
            //TODO TROCAR PARA MBX
            // setState(() {
            //   store.dream!.goalMonth = newValue;
            // });
          },
          min: 25,
          max: 100,
          divisions: 3,
          activeColor: AppColors.colorPink,
          inactiveColor: AppColors.colorEggShell,
          label: getLabelSlide(store.dream.goalMonth!),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ];
  }

  List<Widget> listDefinitionColors() {
    return [
      Row(
        children: <Widget>[
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.colorPrimaryLight,
            child: ClipOval(
              child: Image.asset(
                Utils.getPathAssetsImg("icon_paint.png"),
                width: 35,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 12),
              child: TextUtil.textAccent("Escolha uma cor de representação")),
        ],
      ),

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
    ];
  }

  Step stepConfigDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.CONFIG),
      state: store.getStateStep(StepsEnum.CONFIG),
      title: TextUtil.textTituloStep("Configurações"),
      content: Column(
        children: getListWidgetsConfig(),
      ),
    );
  }

  Step stepInflectionDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.INFLECTION),
      state: store.getStateStep(StepsEnum.INFLECTION),
      title: TextUtil.textTituloStep("Ponto de inflexão"),
      content: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            expansionPanelListInfo(StepsEnum.INFLECTION.index,
                "Aqui você vai definir algo que tenha que fazer, caso suas metas não estejam sendo cumpridas ou alcançadas. É bem simples, o que você precisa fazer a mais para continuar subindo a escada de passos que você definiu."),
            SizedBox(
              height: 20,
            ),
            AppTextDefault(
              name: "Ponto de inflexão",
              icon: Icons.build,
              maxLength: 80,
              controller: store.inflectionTextEditController,
            ),
            SwitchListTile(
              value: store.dream.isInflectionWeek!,
              title: TextUtil.textDefault(
                "Escolher ponto de inflexão diferente para a semana.",
              ),
              // secondary: Icon(Icons.autorenew),
              onChanged: (isInflectionWeek) {
                //TODO trocar para mbx
                // setState(() {
                //   store.dream!.isInflectionWeek = isInflectionWeek;
                // });
              },
            ),
            getInflectionWeek(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget getInflectionWeek() {
    if (store.dream.isInflectionWeek!) {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: AppTextDefault(
          name: "Ponto de inflexão para semana",
          maxLength: 40,
          icon: Icons.build,
          controller: store.inflectionWeekTextEditController,
        ),
      );
    }
    return SizedBox(
      height: 10,
    );
  }

  Step stepRewardDream() {
    return Step(
      isActive: store.checkStepActive(StepsEnum.REWARD),
      state: store.getStateStep(StepsEnum.REWARD),
      title: TextUtil.textTituloStep("Recompensa"),
      content: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            expansionPanelListInfo(StepsEnum.REWARD.index,
                "Defina uma recompensa que você vai ter a cada passo concluido. Isso é muito importante, afinal você merece! Por exemplo, uma comida especial, sair para um lugar novo, jogar um vídeo game, algo que realmente goste!"),
            SizedBox(
              height: 20,
            ),
            AppTextDefault(
              name: "Recompensa",
              icon: Icons.thumb_up,
              maxLength: 80,
              controller: store.rewardTextEditController,
            ),
            SwitchListTile(
              dense: true,
              value: store.dream.isRewardWeek!,
              title: TextUtil.textDefault(
                  "Escolher recompensa diferente para a semana."),
              // secondary: Icon(Icons.autorenew),
              onChanged: (isRewardWeek) {
                //TODO USAR MBX
                // setState(() {
                //   store.dream!.isRewardWeek = isRewardWeek;
                // });
              },
            ),
            getRewardWeek(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget getRewardWeek() {
    if (store.dream.isRewardWeek!) {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: AppTextDefault(
          name: "Recompensa semanal",
          maxLength: 40,
          icon: Icons.thumb_up,
          controller: store.rewardWeekTextEditController,
        ),
      );
    }
    return SizedBox(
      height: 10,
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
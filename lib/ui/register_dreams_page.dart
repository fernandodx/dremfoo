import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/register_dreams_bloc.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/model/color_dream.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/resources/constants.dart';
import 'package:dremfoo/ui/dream_completed_page.dart';
import 'package:dremfoo/ui/home_page.dart';
import 'package:dremfoo/utils/analytics_util.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/alert_bottom_sheet.dart';
import 'package:dremfoo/widget/app_button_default.dart';
import 'package:dremfoo/widget/app_text_default.dart';
import 'package:dremfoo/widget/search_picture_internet.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class RegisterDreamPage extends StatefulWidget {
  Dream dream;
  bool isWait = false;

  RegisterDreamPage({this.dream});

  RegisterDreamPage.fromIsWait(this.isWait);

  @override
  _RegisterDreamPageState createState() => _RegisterDreamPageState();
}

class _RegisterDreamPageState extends State<RegisterDreamPage> {
  final _bloc = RegisterDreamsBloc();

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  void initState() {
    super.initState();

    _bloc.fetch(context, widget.dream, widget.isWait);

    MainEventBus().get(context).streamRegisterDream.listen((TipoEvento tipo) {
      switch (tipo) {
        case TipoEvento.FETCH:
          _bloc.fetch(context, widget.dream, widget.isWait);
          break;
        case TipoEvento.REFRESH:
          refresh();
          break;
      }
    });

    StepsEnum.values.forEach((element) {
      _bloc.listInfoExpanted.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar("Informações do sonho"),
        actions: <Widget>[
          Visibility(
            visible: _bloc.dreamForEdit != null,
            child: IconButton(
              icon: Icon(Icons.cloud_done),
              onPressed: () => _checkDreamCompleted(_bloc.dreamForEdit),
            ),
          ),
          Visibility(
            visible: _bloc.dreamForEdit != null,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _bloc.deleteDream(context),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[bodyRegisterDreamPage(), _bloc.loading()],
      ),
    );
  }

  next() {
    _bloc.currentStep + 1 != _bloc.steps.length
        ? goTo(_bloc.currentStep + 1)
        : finishRegisterDream();
  }

  cancel() {
    if (_bloc.currentStep > 0) {
      goTo(_bloc.currentStep - 1);
    }
  }

  goTo(numberStep) {
    setState(() {
      _bloc.currentStep = numberStep;
    });
  }

  getStepForWin() {
    if (_bloc.stepsForWin == null || _bloc.stepsForWin.isEmpty) {
      _bloc.stepsForWin = [
        AppTextDefault(
          name: "Passo",
          maxLength: 25,
          icon: Icons.queue,
          inputAction: TextInputAction.done,
          controller: _bloc.stepTextEditController,
          onFieldSubmitted: (value) =>
              _bloc.addStepForWin(value, _bloc.stepsForWin.length, context),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: AppButtonDefault(
            onPressed: () => _bloc.addStepForWin(
                _bloc.stepTextEditController.value.text,
                _bloc.stepsForWin.length,
                context),
            icon: Icon(Icons.add_circle),
            label: "Adicionar",
          ),
        ),
      ];
    }

    return _bloc.stepsForWin;
  }

  getDailyGoals() {
    if (_bloc.dailyGoals == null || _bloc.dailyGoals.isEmpty) {
      _bloc.dailyGoals = [
        AppTextDefault(
          name: "Meta diária",
          maxLength: 25,
          icon: Icons.queue,
          inputAction: TextInputAction.done,
          controller: _bloc.dailyGoalTextEditController,
          onFieldSubmitted: (value) =>
              _bloc.addDailyGoals(value, _bloc.dailyGoals.length, context),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          child: AppButtonDefault(
            onPressed: () => _bloc.addDailyGoals(
                _bloc.dailyGoalTextEditController.value.text,
                _bloc.dailyGoals.length,
                context),
            icon: Icon(Icons.add_circle),
            label: "Adicionar",
          ),
        ),
      ];
    }

    return _bloc.dailyGoals;
  }

  finishRegisterDream() {
    setDataDream();
    _bloc.showLoading();

    if (validDataStream()) {
      if (_bloc.dream.reference != null) {
        FirebaseService().updateDream(context, _bloc.dream).then((response) {
          _bloc.hideLoading();
          if (response.ok) {
            AnalyticsUtil.sendAnalyticsEvent(EventRevo.newDream);
            push(context, HomePage(), isReplace: true);
          }
        });
      } else {
        FirebaseService().saveDream(context, _bloc.dream).then((response) {
          _bloc.hideLoading();
          if (response.ok) {
            push(context, HomePage(), isReplace: true);
          }
        });
      }
    }
  }

  refresh() {
    setState(() {});
  }

  StepState getStateStep(StepsEnum stepsEnum) {
    if (_bloc.stepErrors.contains(stepsEnum.index)) {
      return StepState.error;
    }

    if (_bloc.currentStep > stepsEnum.index) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  bool isStepActive(StepsEnum stepsEnum) {
    return _bloc.currentStep >= stepsEnum.index;
  }

  setDataDream() {
    _bloc.dream.dreamPropose = _bloc.dreamTextEditController.text.toString();
    _bloc.dream.reward = _bloc.rewardTextEditController.text.toString();
    _bloc.dream.inflection = _bloc.inflectionTextEditController.text.toString();
    _bloc.dream.rewardWeek = _bloc.rewardWeekTextEditController.text.toString();
    _bloc.dream.inflectionWeek =
        _bloc.inflectionWeekTextEditController.text.toString();
    _bloc.dream.descriptionPropose =
        _bloc.dreamDescriptionTextEditController.text.toString();
  }

  bool validDataStream() {

    String msg = "";

    setState(() {
      _bloc.stepErrors.clear();

      if(_bloc.dream.dreamPropose == null || _bloc.dream.dreamPropose.isEmpty){
        _bloc.stepErrors.add(StepsEnum.DREAM.index);
        msg += "O sonho é obrigatório\n";
      }

      if(_bloc.dream.descriptionPropose == null || _bloc.dream.descriptionPropose.isEmpty){
        _bloc.stepErrors.add(StepsEnum.DREAM.index);
        msg += "A descrição do sonho é obrigatória\n";
      }

      if(_bloc.dream.imgDream == null || _bloc.dream.imgDream.isEmpty){
        _bloc.stepErrors.add(StepsEnum.DREAM.index);
        msg += "A image do sonho é obrigatória\n";
      }

      if (!_bloc.dream.isDreamWait) {
        if (_bloc.dream.steps == null || _bloc.dream.steps.isEmpty) {
          _bloc.stepErrors.add(StepsEnum.STEPS.index);
          msg += "Adicione pelo menos um passo para conquistar\n";
        }

        if (_bloc.dream.dailyGoals == null || _bloc.dream.dailyGoals.isEmpty) {
          _bloc.stepErrors.add(StepsEnum.DAILY_GOALS.index);
          msg += "Adicione pelo menos uma meta diária\n";
        }

        if (_bloc.dream.reward == null || _bloc.dream.reward.isEmpty) {
          _bloc.stepErrors.add(StepsEnum.REWARD.index);
          msg += "A recompensa é obrigatória\n";
        }

        if (_bloc.dream.inflection == null || _bloc.dream.inflection.isEmpty) {
          _bloc.stepErrors.add(StepsEnum.INFLECTION.index);
          msg += "O ponto de inflexão é obrigatório\n";
        }
      }

      if (_bloc.dream.color == null) {
        _bloc.stepErrors.add(StepsEnum.CONFIG.index);
        msg += "Escolha uma cor de representação\n";
      }
    });

    if (_bloc.stepErrors.isNotEmpty) {
      alertBottomSheet(context,
          msg: msg,
          type: TypeAlert.ERROR);
      _bloc.hideLoading();
      return false;
    }

    return true;
  }

  Container bodyRegisterDreamPage() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: _bloc.complete
                ? Center(
                    child: FlareActor(
                      "assets/animations/success_check.flr",
                      shouldClip: true,
                      animation: "show",
                    ),
                  )
                : Stepper(
                    steps: getSteps(),
                    currentStep: _bloc.currentStep,
                    onStepContinue: next,
                    onStepCancel: cancel,
                    onStepTapped: (step) => goTo(step),
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return ButtonBarTheme(
                        data: ButtonBarThemeData(
                            buttonPadding: EdgeInsets.all(6),
                            buttonTextTheme: ButtonTextTheme.accent),
                        child: Container(
                          color: Colors.white,
                          child: ButtonBar(
                            children: [
                              RaisedButton(
                                onPressed: onStepContinue,
                                child: const Text(
                                  'Continuar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: AppColors.colorPrimary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0)),
                              ),
                              FlatButton(
                                onPressed: onStepCancel,
                                child: const Text(
                                  'Anterior',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    if (_bloc.dream.isDreamWait) {
      _bloc.steps = [
        stepInfoDream(),
        stepConfigDream(),
      ];
    } else {
      _bloc.steps = [
        stepInfoDream(),
        stepGoalDream(),
        stepGoalDaily(),
        stepRewardDream(),
        stepInflectionDream(),
        stepConfigDream(),
      ];
    }

    return _bloc.steps;
  }

  Step stepConfigDream() {
    return Step(
      isActive: isStepActive(StepsEnum.CONFIG),
      state: getStateStep(StepsEnum.CONFIG),
      title: TextUtil.textTituloStep("Configurações"),
      content: Column(
        children: getListWidgetsConfig(),
      ),
    );
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
          value: _bloc.dream.goalWeek,
          onChanged: (newValue) {
            setState(() {
              _bloc.dream.goalWeek = newValue;
            });
          },
          min: 25,
          max: 100,
          divisions: 3,
          activeColor: AppColors.colorPink,
          inactiveColor: AppColors.colorEggShell,
          label: getLabelSlide(_bloc.dream.goalWeek),
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
          value: _bloc.dream.goalMonth,
          onChanged: (newValue) {
            setState(() {
              _bloc.dream.goalMonth = newValue;
            });
          },
          min: 25,
          max: 100,
          divisions: 3,
          activeColor: AppColors.colorPink,
          inactiveColor: AppColors.colorEggShell,
          label: getLabelSlide(_bloc.dream.goalMonth),
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
      Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: FutureBuilder(
            future: FirebaseService().findAllColorsDream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ResponseApi<List<ColorDream>> responseApi = snapshot.data;
                if (responseApi.ok) {
                  return getListviewColors(responseApi.result);
                }
              }

              return _bloc.getSimpleLoadingWidget(size: 100);
            }),
      ),
    ];
  }

  Step stepInflectionDream() {
    return Step(
      isActive: isStepActive(StepsEnum.INFLECTION),
      state: getStateStep(StepsEnum.INFLECTION),
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
              controller: _bloc.inflectionTextEditController,
            ),
            SwitchListTile(
              value: _bloc.dream.isInflectionWeek,
              title: TextUtil.textDefault(
                "Escolher ponto de inflexão diferente para a semana.",
              ),
              // secondary: Icon(Icons.autorenew),
              onChanged: (isInflectionWeek) {
                setState(() {
                  _bloc.dream.isInflectionWeek = isInflectionWeek;
                });
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

  Step stepRewardDream() {
    return Step(
      isActive: isStepActive(StepsEnum.REWARD),
      state: getStateStep(StepsEnum.REWARD),
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
              controller: _bloc.rewardTextEditController,
            ),
            SwitchListTile(
              dense: true,
              value: _bloc.dream.isRewardWeek,
              title: TextUtil.textDefault(
                  "Escolher recompensa diferente para a semana."),
              // secondary: Icon(Icons.autorenew),
              onChanged: (isRewardWeek) {
                setState(() {
                  _bloc.dream.isRewardWeek = isRewardWeek;
                });
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

  Step stepGoalDaily() {
    return Step(
      isActive: isStepActive(StepsEnum.DAILY_GOALS),
      state: getStateStep(StepsEnum.DAILY_GOALS),
      title: TextUtil.textTituloStep(
        "Metas diárias",
      ),
      content: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            expansionPanelListInfo(StepsEnum.DAILY_GOALS.index,
                "Agora defina metas diárias para conquistar seus passos, se concentre no primeiro passo e trace suas metas, após a conclusão você pode adicionar outras metas diárias."),
            SizedBox(
              height: 20,
            ),
            Column(
              children: getDailyGoals(),
            ),
          ],
        ),
      ),
    );
  }

  Step stepGoalDream() {
    return Step(
      isActive: isStepActive(StepsEnum.STEPS),
      state: getStateStep(StepsEnum.STEPS),
      title: TextUtil.textTituloStep("Passos para conquistar"),
      content: Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            expansionPanelListInfo(StepsEnum.STEPS.index,
                "Defina passos que você precisa cumprir antes de realizar o sonho, como se estivesse subindo uma escada."),
            SizedBox(
              height: 20,
            ),
            Column(
              children: getStepForWin(),
            ),
          ],
        ),
      ),
    );
  }

  Widget expansionPanelListInfo(int indexList, String subtitle) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpansive) {
        setState(() {
          _bloc.listInfoExpanted[indexList] = isExpansive ? false : true;
          print(_bloc.listInfoExpanted);
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: TextUtil.textAccent("Informações"),
              leading: Icon(
                Icons.info_outline,
                color: AppColors.colorAcent,
              ),
              onTap: () {
                setState(() {
                  _bloc.listInfoExpanted[indexList] =
                      _bloc.listInfoExpanted[indexList] ? false : true;
                });
              },
            );
          },
          body: Container(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: TextUtil.textSubTitle(subtitle),
          ),
          isExpanded: _bloc.listInfoExpanted[indexList],
        )
      ],
    );
  }

  Step stepInfoDream() {
    return Step(
        isActive: isStepActive(StepsEnum.DREAM),
        state: getStateStep(StepsEnum.DREAM),
        title: TextUtil.textTituloStep("Qual o seu sonho?"),
        content: Column(
          children: <Widget>[
            AppTextDefault(
              name: "Sonho",
              controller: _bloc.dreamTextEditController,
              icon: Icons.cloud,
              maxLength: 35,
            ),
            SizedBox(
              height: Constants.SIZE_HEIGHT_DEFAULT,
            ),
            AppTextDefault(
              name: "Descrição do sonho",
              controller: _bloc.dreamDescriptionTextEditController,
              icon: Icons.description,
              maxLength: 60,
            ),
            SizedBox(
              height: Constants.SIZE_HEIGHT_DEFAULT,
            ),
            TextUtil.textAccent("Escolha uma imagem que lembra esse sonho."),
            SizedBox(
              height: Constants.SIZE_HEIGHT_DEFAULT,
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                child: _bloc.getImageDream(),
                // onTap: () => addPickImage(context),
                onTap: () {
                  // searchImageOrGallery();//FAlta integrar com a escolha e a galeria.

                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          color: AppColors.colorEggShell,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.image),
                                    ),
                                    TextUtil.textSubTitle("Pesquisar na galeria", align: TextAlign.center),
                                  ],
                                ),
                                onTap: () {
                                  addPickImage(context);
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(width: 20,),
                              InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      child: Icon(Icons.wifi_tethering),
                                    ),
                                    TextUtil.textSubTitle("Pesquisar na internet", align: TextAlign.center),
                                  ],
                                ),
                                onTap: () {
                                  searchImageOrGallery();
                                },
                              )
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
            SizedBox(
              height: Constants.SIZE_HEIGHT_DEFAULT,
            ),
            Visibility(
              visible: _bloc.dream.isDreamWait,
              child: SwitchListTile(
                title: TextUtil.textDefault("Sonho em espera"),
                subtitle: TextUtil.textSubTitle("Retirando seu sonho do modo espera, você vai precisar definir etapas e metas diárias"),
                value: _bloc.dream.isDreamWait,
                onChanged: (value)  {
                  
                  alertBottomSheet(
                      context,
                      msg: "Retirando a opção de espera, você vai precisar definir passo e metas diárias para esse sonho e não vai ser mais possível colocar ele em espera, deseja continuar?",
                      nameButtonDefault: "Sim",
                      onTapDefaultButton: () {
                        updateDreamWaitForGoal(value);
                      },
                      title: "Alerta",
                      type: TypeAlert.ALERT,
                      listButtonsAddtional: [
                        FlatButton(
                          child: Text("Não"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ]);
                },
              ),
            ),
          ],
        ));
  }

  void updateDreamWaitForGoal(bool value) {
     _bloc.dream.isDreamWait = value;
    _bloc.showLoading();
                     
    if(_bloc.dream.uid == null || _bloc.dream.uid.isEmpty){
      push(context, RegisterDreamPage(), isReplace: true);
    }else{
      FirebaseService().updateDream(context, _bloc.dream).then((response) {
        if (response.ok) {
          _bloc.hideLoading();
          AnalyticsUtil.sendAnalyticsEvent(EventRevo.updateDreamFocus);
          push(context, RegisterDreamPage(dream: _bloc.dream,), isReplace: true);
        }
      });
    }
  }

  Future searchImageOrGallery() async {
    String sonho = _bloc.dreamTextEditController.text;
    if(sonho.isNotEmpty && sonho.contains(" ")){
      sonho = sonho.split(" ").last;
    }
    SearchPictureInternet search = SearchPictureInternet(sonho);
    search.stream.listen((String fotoBase64) {
      setState(() {
        _bloc.dream.imgDream = fotoBase64;
        Navigator.pop(context);
      });
    });
    push(context, search);

    AnalyticsUtil.sendAnalyticsEvent(EventRevo.addImageDreamInternet);
  }

  Future addPickImage(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File compressedImg = await FlutterNativeImage.compressImage(image.path,
        quality: 90, targetWidth: 600, targetHeight: 600);

    List<int> imageBytes = compressedImg.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    setState(() {
      _bloc.dream.imgDream = base64Image;
    });

    AnalyticsUtil.sendAnalyticsEvent(EventRevo.addImageDream);
  }

  ListView getListviewColors(List<ColorDream> listColors) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listColors.length,
        itemBuilder: (context, index) {
          Color color = Utils.colorFromHex(listColors[index].primary);
          return InkWell(
            child: Container(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: getIconColor(color),
              ),
            ),
            onTap: () {
              setState(() {
                _bloc.dream.color = listColors[index];
              });
            },
          );
        });
  }

  Icon getIconColor(Color color) {
    if (_bloc.dream.color != null &&
        _bloc.dream.color.primary.toUpperCase() ==
            Utils.colorToHex(color, leadingHashSign: false).toUpperCase()) {
      return Icon(
        Icons.check,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.adjust,
        color: Colors.white,
      );
    }
  }

  Widget getRewardWeek() {
    if (_bloc.dream.isRewardWeek) {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: AppTextDefault(
          name: "Recompensa semanal",
          maxLength: 40,
          icon: Icons.thumb_up,
          controller: _bloc.rewardWeekTextEditController,
        ),
      );
    }
    return SizedBox(
      height: 10,
    );
  }

  Widget getInflectionWeek() {
    if (_bloc.dream.isInflectionWeek) {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: AppTextDefault(
          name: "Ponto de inflexão para semana",
          maxLength: 40,
          icon: Icons.build,
          controller: _bloc.inflectionWeekTextEditController,
        ),
      );
    }
    return SizedBox(
      height: 10,
    );
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
  }

  _checkDreamCompleted(Dream dream) {
    bool isStepsCompleted = true;

    dream.steps.forEach((step) {
      if (!step.isCompleted) {
        isStepsCompleted = false;
        return;
      }
    });

    if (isStepsCompleted) {
      alertBottomSheet(context,
          msg: "Você conquistou o seu sonho: ${dream.dreamPropose}?",
          title: "Realização do sonho!",
          nameButtonDefault: "SIM", onTapDefaultButton: () {
        AnalyticsUtil.sendAnalyticsEvent(EventRevo.dreamFinish);
        _bloc.dreamCompleted();
        push(context, DreamCompletedPage(dream));
      }, listButtonsAddtional: [
        FlatButton(
          child: Text("AINDA NÃO"),
          onPressed: () {
            print("Ainda não");
            Navigator.pop(context);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        )
      ]);
    } else {
      alertBottomSheet(
        context,
        msg:
            "Ainda existem etapas do sonho ${dream.dreamPropose} a serem concluidas, vamos lá!",
      );
    }
  }
}

enum StepsEnum { DREAM, STEPS, DAILY_GOALS, REWARD, INFLECTION, CONFIG }

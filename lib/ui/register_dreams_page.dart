import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/register_dreams_bloc.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/ui/home_page.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/alert_bottom_sheet.dart';
import 'package:dremfoo/widget/app_text_default.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterDreamPage extends StatefulWidget {

  Dream dream;
  RegisterDreamPage({this.dream});

  @override
  _RegisterDreamPageState createState() => _RegisterDreamPageState();
}

class _RegisterDreamPageState extends State<RegisterDreamPage> {

  final _bloc = RegisterDreamsBloc();

  next() {
    _bloc.currentStep + 1 !=  _bloc.steps.length
        ? goTo( _bloc.currentStep + 1)
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
          icon: Icons.queue,
          inputAction: TextInputAction.done,
          controller: _bloc.stepTextEditController,
          onFieldSubmitted: (value) => _bloc.addStepForWin(value,  _bloc.stepsForWin.length, refresh()),
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
          icon: Icons.queue,
          inputAction: TextInputAction.done,
          controller: _bloc.dailyGoalTextEditController,
          onFieldSubmitted: (value) => _bloc.addDailyGoals(value,  _bloc.dailyGoals.length, refresh()),
        ),
      ];
    }

    return _bloc.dailyGoals;
  }

  finishRegisterDream(){

    setDataDream();
    validDataStream();

    // Chamar Loading

    if(_bloc.dream.reference != null){
      FirebaseService().updateDream(context, _bloc.dream).then((response){
        if(response.ok){
          push(context, HomePage(), isReplace: true);
        }
      });
    }else{
      //TODO Fazer loading
      FirebaseService().saveDream(context, _bloc.dream).then((response){
        if(response.ok){
          push(context, HomePage(), isReplace: true);
        }
      });
    }


  }

  refresh(){
    setState(() {

    });
  }

  StepState getStateStep(StepsEnum stepsEnum){
    if(_bloc.stepErrors.contains(stepsEnum.index)){
      return StepState.error;
    }

    if(_bloc.currentStep > stepsEnum.index){
      return StepState.complete;
    }else{
      return StepState.indexed;
    }
  }

  bool isStepActive(StepsEnum stepsEnum){
    return _bloc.currentStep >= stepsEnum.index;
  }


  setDataDream(){
    _bloc.dream.dreamPropose = _bloc.dreamTextEditController.text.toString();
    _bloc.dream.reward = _bloc.rewardTextEditController.text.toString();
    _bloc.dream.inflection = _bloc.inflectionTextEditController.text.toString();
  }

  validDataStream(){

    setState(() {
      _bloc.stepErrors.clear();

      if((_bloc.dream.imgDream == null || _bloc.dream.imgDream.isEmpty)
          || (_bloc.dream.dreamPropose == null || _bloc.dream.dreamPropose.isEmpty)){
        _bloc.stepErrors.add(StepsEnum.DREAM.index);
      }

      if(_bloc.dream.steps == null || _bloc.dream.steps.isEmpty){
        _bloc.stepErrors.add(StepsEnum.STEPS.index);
      }

      if(_bloc.dream.reward == null || _bloc.dream.reward.isEmpty){
        _bloc.stepErrors.add(StepsEnum.REWARD.index);
      }

      print(_bloc.dream.inflection);
      if(_bloc.dream.inflection == null || _bloc.dream.inflection.isEmpty){
        _bloc.stepErrors.add(StepsEnum.INFLECTION.index);
      }
    });

    if(_bloc.stepErrors.isNotEmpty){
      alertBottomSheet(context, msg: "Todos os campos são obrigatórios.", type: TypeAlert.ERROR);
    }

  }

  @override
  void initState() {
    super.initState();

    _bloc.fetch(widget.dream, refresh);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar("Cadastro do Sonho"),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _bloc.complete
                  ? Center(
                      child: Container(
                        child: TextUtil.textTitulo("OK"),
                        color: Colors.blueGrey,
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
                              buttonPadding: EdgeInsets.all(12),
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
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                FlatButton(
                                  onPressed: onStepCancel,
                                  child: const Text(
                                    'Anterior',
                                    style: TextStyle(
                                        color: AppColors.colorPrimary),
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
      ),
    );
  }

  List<Step> getSteps() {
    _bloc.steps = [
      Step(
          isActive: isStepActive(StepsEnum.DREAM),
          state: getStateStep(StepsEnum.DREAM),
          title: TextUtil.textDefault("Qual o seu sonho?"),
          content: Column(
            children: <Widget>[
              AppTextDefault(name: "Sonho", controller: _bloc.dreamTextEditController, icon: Icons.cloud,),
              SizedBox(
                height: 20,
              ),
              TextUtil.textAccent("Escolha uma imagem que lembra esse sonho."),
              Container(
                padding: EdgeInsets.all(8),
                height: 180,
                width: 500,
                child: getStreamBuilder(context)
              )
            ],
          )),
      Step(
        isActive: isStepActive(StepsEnum.STEPS),
        state:  getStateStep(StepsEnum.STEPS),
        title: TextUtil.textDefault("Passos para conquistar"),
        content: Column(
          children: <Widget>[
            Container(
              height: 80,
              width: 500,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 8,
                    child: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.colorPrimaryLight,
                        child: ClipOval(
                            child: Image.asset(
                                Utils.getPathAssetsImg("icon_steps.png"), width: 35))),
                  ),
                  Positioned(
                    left: 55,
                    top: 0,
                    child: TextUtil.textAccent("Defina passos que você precisa\ncumprir antes de realizar o sonho,\ncomo se estivesse subindo uma escada."),
                  ),
                ],
              ),
            ),
            Column(
              children: getStepForWin(),
            ),
          ],
        ),
      ),
      Step(
        isActive: isStepActive(StepsEnum.DAILY_GOALS),
        state:  getStateStep(StepsEnum.DAILY_GOALS),
        title: TextUtil.textDefault("Metas diárias"),
        content: Column(
          children: <Widget>[
            Container(
              height: 110,
              width: 500,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 28,
                    child: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.colorPrimaryLight,
                        child: ClipOval(
                            child: Image.asset(
                                Utils.getPathAssetsImg("icon_steps.png"), width: 35))),
                  ),
                  Positioned(
                    left: 55,
                    top: 0,
                    child: TextUtil.textAccent("Agora defina metas diárias para\nconquistas seus passos, se concentre\nno primeiro passo e trace suas metas,\napós a conclusão você pode\nadicionar outras metas diárias."),
                  ),
                ],
              ),
            ),
            Column(
              children: getDailyGoals(),
            ),
          ],
        ),
      ),
      Step(
        isActive: isStepActive(StepsEnum.REWARD),
        state: getStateStep(StepsEnum.REWARD),
        title: TextUtil.textDefault("Recompensa"),
        content: Column(
          children: <Widget>[
            Container(
              height: 130,
              width: 500,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 38,
                    child: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.colorPrimaryLight,
                        child: ClipOval(
                            child: Image.asset(
                                Utils.getPathAssetsImg("icon_reward.png"), width: 35,))),
                  ),
                  Positioned(
                    left: 55,
                    top: 0,
                    child: TextUtil.textAccent("Defina uma recompensa que você vai ter\na cada passo concluido. Isso é muito\nimportante, afinal você merece!\nPor exemplo, uma comida especial, sair\npara um lugar novo, jogar um vídeo game,\nalgo que realmente goste!"),
                  ),
                ],
              ),
            ),
            AppTextDefault(
              name: "Recompensa",
              icon: Icons.thumb_up,
              controller: _bloc.rewardTextEditController,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      Step(
          isActive: isStepActive(StepsEnum.INFLECTION),
          state: getStateStep(StepsEnum.INFLECTION),
          title: TextUtil.textDefault("Ponto de inflexão"),
          content: Column(
            children: <Widget>[
              Container(
                height: 130,
                width: 500,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 38,
                      child: CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.colorPrimaryLight,
                          child: ClipOval(
                              child: Image.asset(
                                  Utils.getPathAssetsImg("icon_inflection.png"), width: 35))),
                    ),
                    Positioned(
                      left: 55,
                      top: 0,
                      child: TextUtil.textAccent("Aqui você vai definir algo que tenha que\nfazer, caso suas metas não estejam sendo\ncumpridas ou alcansadas. É bem simples,\no que você precisa fazer a mais para\ncontinuar subindo a escada de passos\nque você definiu."),
                    ),
                  ],
                ),
              ),
              AppTextDefault(
                name: "Ponto de inflexão",
                icon: Icons.build,
                controller: _bloc.inflectionTextEditController,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          )),
    ];

    return _bloc.steps;
  }

  StreamBuilder<Widget> getStreamBuilder(context) {
    return StreamBuilder(
      stream: _bloc.streamImgDream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return TextUtil.textTitulo("Erro ao carregar a imagem");
        }

        if (snapshot.hasData) {
          return InkWell(
            child: snapshot.data,
            onTap: () => _bloc.addImage(context),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }


}

enum StepsEnum{

  DREAM, STEPS, DAILY_GOALS, REWARD, INFLECTION

}

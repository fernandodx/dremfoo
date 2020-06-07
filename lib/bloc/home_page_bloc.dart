import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/model/chart_goals.dart';
import 'package:dremfoo/model/daily_goal.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/status_dream.dart';
import 'package:dremfoo/model/step_dream.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/ui/register_dreams_page.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/card_dream.dart';
import 'package:flutter/material.dart';

class HomePageBloc {
  final _addDreamStreamController = StreamController<List<Dream>>();
  final _addChipStepsStreamController = StreamController<List<Widget>>();
  final _addChipDailyStreamController = StreamController<List<Widget>>();
  final _addChartStreamController = StreamController<List<Widget>>();


  Stream<List<Dream>> get streamDream => _addDreamStreamController.stream;

  Stream<List<Widget>> get streamChipSteps => _addChipStepsStreamController.stream;

  Stream<List<Widget>> get streamChipDailyGoal => _addChipDailyStreamController.stream;

  Stream<List<Widget>> get streamChartSteps => _addChartStreamController.stream;

  List<Dream> listDream = [];

  void fetch() {

    getSteps();
  }

  CollectionReference getDream() {
    ResponseApi<CollectionReference> responseApi =
        FirebaseService().findDreams();

    if (responseApi.ok) {
      return responseApi.result;
    }

    return null; // verificar como tratar erros
  }

  getSteps() async {
    CollectionReference dreamsRef = getDream();

    QuerySnapshot querySnapshot = await dreamsRef.getDocuments();

    List<Dream> listDream = List();
    List<Widget> listChartWidget = List();
    List<StepDream> listAllStep = List();
    List<DailyGoal> listAllDailyGoal = List();

    if(querySnapshot.documents.isEmpty) {
      _addDreamStreamController.add(listDream);
      return;
    }

    for (DocumentSnapshot dreamSnapshot in querySnapshot.documents) {

      List<StepDream> listStep = List();
      List<DailyGoal> listDailyGoals = List();
      Dream dream = Dream.fromMap(dreamSnapshot.data);
      dream.uid = dreamSnapshot.documentID;
      dream.reference = dreamSnapshot.reference;

      ResponseApi<CollectionReference> responseStepApi = FirebaseService().findSteps(dream);
      ResponseApi<CollectionReference> responseDailyApi= FirebaseService().findDailyGoals(dream);

      if (responseDailyApi.ok) {
        QuerySnapshot querySnapshotSteps = await responseDailyApi.result.orderBy("position").getDocuments();

        for (DocumentSnapshot daily in querySnapshotSteps.documents) {
          DailyGoal dailyGoal = DailyGoal.fromMap(daily.data);
          dailyGoal.reference = daily.reference;
          listDailyGoals.add(dailyGoal);
        }

        dream.dailyGoals = listDailyGoals;
      }

      if (responseStepApi.ok) {
        QuerySnapshot querySnapshotSteps = await responseStepApi.result.orderBy("position").getDocuments();

        for (DocumentSnapshot step in querySnapshotSteps.documents) {
          StepDream stepDream = StepDream.fromMap(step.data);
          stepDream.uid = step.documentID;
          stepDream.reference = step.reference;
          stepDream.dreamPropose = dream.dreamPropose;
          listStep.add(stepDream);
        }

        dream.steps = listStep;
      }

      listDream.add(dream);
      listAllStep.addAll(listStep);
      listAllDailyGoal.addAll(listDailyGoals);
    }

    getStepChips(listAllStep, () {
      getSteps();
    });

    getDailyChips(listAllDailyGoal, (){
      getSteps();
    });

    _addDreamStreamController.add(listDream);
    List<List<ChartGoals>> listGoalsWeek = await getDataChartWeek(listDream);

    Widget chartWeek = ChartGoals.createChartWeek("Sua semana", listGoalsWeek);
    listChartWidget.add(chartWeek);

    Widget chartMonth = await _createBarMouth(listDream);
    listChartWidget.add(chartMonth);

    _addChartStreamController.add(listChartWidget);

  }

  Future<Widget> _createBarMouth(List<Dream> listDream) async {
//    var listGoals =  await getDataChartJoin(listDream);
//    int countBar = listGoals[0].length * listGoals.length;
//    if (countBar > 15) { //TODO descobrir uma maneira melhor de contar as barras
      List<ChartGoals> listGoals = await getDataChartMouth(listDream);
      return ChartGoals.createBarChartMouth(listGoals);
//    } else {
//      return ChartGoals.createBarChartJoinMouth(listGoals);
//    }
  }


  List<CardDream> getlistCardDream(BuildContext context) {
    List<CardDream> listCardDream = List<CardDream>();

    for (Dream dream in listDream) {
      CardDream cardDream = CardDream(
        imgBase64: dream.imgDream,
        selected: false,
        onTap: () => _editDream(context, dream),
        title: dream.dreamPropose,
        subTitle: dream.descriptionPropose,
      );

      listCardDream.add(cardDream);
    }

    return listCardDream;
  }

  List<CardDream> getlistCardDreamFire(
      BuildContext context, List<Dream> listDream) {
    List<CardDream> listCardDream = List<CardDream>();

    for (Dream dream in listDream) {
      CardDream cardDream = CardDream(
        imgBase64: dream.imgDream,
        selected: false,
        onTap: () => _editDream(context, dream),
        title: dream.dreamPropose,
        subTitle: dream.descriptionPropose != null
            ? dream.descriptionPropose
            : "Falta implementar",
      );

      listCardDream.add(cardDream);
    }

    listCardDream.add(CardDream(imageAsset: Utils.getPathAssetsImg("icon_add_dream.png"),
                      selected: false,
                      isCardAdd: true,
                      onTap: () => _addDream(context),
                      title: "Novo sonho",
                    ));

    return listCardDream;
  }

  Future<List<Widget>> getStepChips(List<StepDream> steps, Function restart) async {
    List<Widget> listWidget = await verifyCheckChipStep(steps, restart);
    _addChipStepsStreamController.add(listWidget);
    return listWidget;
  }

  Future<List<Widget>> getDailyChips(List<DailyGoal> dailys, Function restart) async {
    List<Widget> listWidget = await verifyCheckChipDaily(dailys, restart);
    _addChipDailyStreamController.add(listWidget);
    return listWidget;
  }

  Future verifyCheckChipStep(List<StepDream> steps, Function restart) async {
    List<Widget> listWidget = List();

    for (StepDream stepDream in steps) {

//      ResponseApi<bool> response =
//          await FirebaseService().findStepToday(stepDream.step);

      ChoiceChip chip = ChoiceChip(
        elevation: 8,
        label: Text(
          stepDream.step,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        selectedColor: AppColors.colorPrimary,
        selected: stepDream.isCompleted,
        avatar: stepDream.isCompleted
            ? Icon(
                Icons.check,
                color: Colors.white,
              )
            : CircleAvatar(
          backgroundColor: AppColors.colorDarkLight,
          child: TextUtil.textDefault("${stepDream.position}˚", color: Colors.white),),
        onSelected: (selected) {
          stepDream.isCompleted = selected;
          stepDream.dateCompleted = Timestamp.now();
//          FirebaseService().updateStepToday(stepDream.step, selected);
          FirebaseService().updateStepDream(stepDream);
          restart();
        },
      );

      listWidget.add(Container(
          margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }

    return listWidget;
  }

  Future verifyCheckChipDaily(List<DailyGoal> listDailyGoals, Function restart) async {
    List<Widget> listWidget = List();

    for (DailyGoal daily in listDailyGoals) {
      ChoiceChip chip = ChoiceChip(
        elevation: 8,
        label: Text(
          daily.nameDailyGoal,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey,
        selectedColor: AppColors.colorPrimary,
        selected: daily.isCompletedToday(),
        avatar: daily.isCompletedToday()
            ? Icon(
          Icons.check,
          color: Colors.white,
        )
            : CircleAvatar(
          backgroundColor: AppColors.colorDarkLight,
          child: TextUtil.textDefault("${daily.position}˚", color: Colors.white),),
        onSelected: (selected) {

          daily.lastDateCompleted = selected ? Timestamp.now() : null;
          FirebaseService().updateDailyGoal(daily);
          restart();

        },
      );

      listWidget.add(Container(
          margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }

    return listWidget;
  }


  Future<List<List<ChartGoals>>> getDataChartWeek(List<Dream> listDream) async {
    List<List<ChartGoals>> listDataChartGoals = List();

    for (Dream dream in listDream) {
      List<ChartGoals> listWeek = List();
      List<DailyGoal> listDaily = dream.dailyGoals;

      int maxStep = listDaily.length;
      int maxPointsWeek = 7 * maxStep;
      double percent = 0;

      DateTime now = DateTime.now();
      DateTime firstDay = now.subtract(Duration(days: now.weekday));

      int qtdDayFirstDay = DateUtil().daysPastInYear(firstDay.month, firstDay.day, firstDay.year);
      int qtdDayNow = DateUtil().daysPastInYear(now.month, now.day,now.year);

      //Verificar se é domingo, caso sim, a comparação tem que ser com o dia de hoje e não com o first
      bool isSunday = (qtdDayNow - qtdDayFirstDay) == 7;
      int progress = isSunday ?  1 : (qtdDayNow - qtdDayFirstDay)+1;

      List<DailyGoal> listDailyOk = List();

      ResponseApi<List<DailyGoal>> responseApi = await FirebaseService().findDailyGoalsCompletedHist(dream, firstDay, now);
      if(responseApi.ok){
        listDailyOk = responseApi.result;
      }

      for (int i = 1; i <= progress; i++) {
        int totalDaysOk = 0;

        for(DailyGoal daily in listDailyOk){
          if(firstDay.day == daily.lastDateCompleted.toDate().day || (isSunday && now.day == daily.lastDateCompleted.toDate().day)){
            totalDaysOk++;
          }
        }

        if (totalDaysOk > 0) {
          percent = percent + (totalDaysOk / maxPointsWeek) * 100;
        }
        listWeek.add(ChartGoals(
            i.toDouble(), percent, AppColors.colorFromHex(dream.colorHex)));
        firstDay = firstDay.add(Duration(days: 1));
      }

      listDataChartGoals.add(listWeek);
    }

    return listDataChartGoals;
  }

  Future<List<ChartGoals>> getDataChartMouth(List<Dream> listDream) async {

    List<ChartGoals> listMouth = List();

    int maxStep = 0;

    listDream.forEach((dream) {
      maxStep = maxStep + dream.steps.length;
    });

    double percent = 0;

    DateTime now = DateTime.now();
    DateTime firstMouth = DateTime(now.year, 1, 1);

    for (int i = 1; i <= now.month; i++) {
      int countDailyOk = 0;
      List<DailyGoal> listAllDaily = List();

      for(Dream dream in listDream){
        ResponseApi<List<DailyGoal>> responseApi = await FirebaseService().findDailyGoalsCompletedHist(dream, firstMouth, now);
        if(responseApi.ok){
          listAllDaily.addAll(responseApi.result);
        }
      }

      for(DailyGoal daily in listAllDaily){
        if(daily.lastDateCompleted.toDate().month == firstMouth.month){
          countDailyOk++;
        }
      }

      int dayInMouth = DateUtil().daysInMonth(i, firstMouth.year);
      int maxPointsMouth = dayInMouth * maxStep;

      if (countDailyOk > 0) {
        percent = (countDailyOk / maxPointsMouth) * 100;
      }
      listMouth.add(ChartGoals(i.toDouble(), percent, Colors.lightGreenAccent));
      firstMouth =
          DateTime(firstMouth.year, firstMouth.month + 1, firstMouth.day);
    }

    return listMouth;
  }

  Future<List<List<ChartGoals>>> getDataChartJoin(List<Dream> listDream) async {

    List<List<ChartGoals>> listData = List();
    for(Dream dream in listDream) {
      List<ChartGoals> listGoals = await _getDataChartForDreamMouth(dream);
      listData.add(listGoals);
    }

    return listData;
  }

  //TODO os steps tem que ser do Dream

  Future<List<ChartGoals>> _getDataChartForDreamMouth(Dream dream) async {
    List<ChartGoals> listMouth = List();

    DateTime now = DateTime.now();
    DateTime firstMouth = DateTime(now.year, 1, 1);

    List<DailyGoal> dailyGoals = List();
    ResponseApi<List<DailyGoal>> responseApi = await FirebaseService().findDailyGoalsCompletedHist(dream, firstMouth, now);
    if(responseApi.ok){
      dailyGoals = responseApi.result;
    }

    for (int i = 1; i <= now.month; i++) {

      int maxStep = dream.dailyGoals.length;
      int dayInMouth = DateUtil().daysInMonth(i, firstMouth.year);
      int maxPointsMouth = dayInMouth * maxStep;


      int countDailyOk = 0;
      for(DailyGoal daily in dailyGoals){
        if(firstMouth.month == daily.lastDateCompleted.toDate().month){
          countDailyOk++;
        }
      }
      double percent = 0;

      if (countDailyOk > 0) {
        percent = (countDailyOk / maxPointsMouth) * 100;
      }
      listMouth.add(ChartGoals(i.toDouble(), percent, AppColors.colorFromHex(dream.colorHex)));
      firstMouth = DateTime(firstMouth.year, firstMouth.month + 1, firstMouth.day);
    }

    return listMouth;
  }

  _editDream(BuildContext context, Dream dream) {
    RegisterDreamPage pageEdit = RegisterDreamPage(
      dream: dream,
    );
    push(context, pageEdit);
  }

  _addDream(BuildContext context) {
    push(context, RegisterDreamPage());
  }
}

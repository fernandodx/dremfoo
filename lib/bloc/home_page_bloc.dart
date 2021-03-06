import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/base_bloc.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/model/chart_goals.dart';
import 'package:dremfoo/model/daily_goal.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/hist_goal_month.dart';
import 'package:dremfoo/model/hist_goal_week.dart';
import 'package:dremfoo/model/notification_revo.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/step_dream.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/model/user_focus.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/ui/check_type_dream_page.dart';
import 'package:dremfoo/ui/register_dreams_page.dart';
import 'package:dremfoo/ui/report_dreams_month.dart';
import 'package:dremfoo/ui/report_dreams_week.dart';
import 'package:dremfoo/utils/crashlytics_util.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/notification_util.dart';
import 'package:dremfoo/utils/prefs.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/card_dream.dart';
import 'package:flutter/material.dart';

class HomePageBloc extends BaseBloc {
  final _addDreamStreamController = StreamController<List<Dream>>();
  final _addChipStepsStreamController = StreamController<List<Widget>>();
  final _addChipDailyStreamController = StreamController<List<Widget>>();
  final _addChartStreamController = StreamController<List<Widget>>();

  final _addCheckSucessStreamController = StreamController<bool>();

  Stream<List<Dream>> get streamDream => _addDreamStreamController.stream;

  Stream<List<Widget>> get streamChipSteps => _addChipStepsStreamController.stream;

  Stream<List<Widget>> get streamChipDailyGoal => _addChipDailyStreamController.stream;

  Stream<List<Widget>> get streamChartSteps => _addChartStreamController.stream;

  Stream<bool> get streamCheckSucess => _addCheckSucessStreamController.stream;

  List<Dream> listDream = [];

  DateTime _currentDate = DateTime.now();
  String titlePage;

  bool isVisibilityStep = true;

  void fetch(BuildContext context, bool isShowLoadind) async {
    try {
      titlePage = "Painel · ${Utils.dateToStringExtension(_currentDate)}";
      if (isShowLoadind) {
        showLoading();
      }
      ResponseApi response = await FirebaseService().findRankUser();
      isVisibilityStep = await isVisibilityStepPrefs(true);
      await getSteps(context);
      if (isShowLoadind) {
        hideLoading();
      }
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
  }

  dispose() {
    super.dispose();
    _addDreamStreamController.close();
    _addChipStepsStreamController.close();
    _addChipDailyStreamController.close();
    _addChartStreamController.close();
    _addCheckSucessStreamController.close();
  }

  Future<List<UserRevo>> getRankUsers() async {
    ResponseApi responseApi =  await FirebaseService().findRankUser();
    if(responseApi.ok){
      return responseApi.result;
    }

    return Future.error(responseApi.msg);
  }

  void saveLastFocus() async {
    ResponseApi<UserRevo> responseApi = await FirebaseService().findDataUser();
    if (responseApi.ok) {
      UserFocus focus = responseApi.result.focus;

      if (focus == null) {
        focus = UserFocus();
      }

      //Save data
      if (focus.dateInit == null) {
        focus.dateInit = Timestamp.now();
      }

      DateTime dateInit = focus.dateInit.toDate();
      DateTime dateNow = DateTime.now();

      int countDayInit = DateUtil().totalLengthOfDays(dateInit.month, dateInit.day, dateInit.year);
      int countDayNow = DateUtil().totalLengthOfDays(dateNow.month, dateNow.day, dateNow.year);

      focus.dateLastFocus = Timestamp.now();
      focus.countDaysFocus = countDayNow - countDayInit;

      FirebaseService().saveLastFocus(focus);
    }
  }

  UserFocus getMockLastFocus(DateTime dateInit, DateTime dateLast) {
    UserFocus focus = UserFocus();
    focus.dateInit = Timestamp.fromDate(dateInit);
    focus.dateLastFocus = Timestamp.fromDate(dateLast);
    int countDayInit = DateUtil().totalLengthOfDays(dateInit.month, dateInit.day, dateInit.year);
    int countDayLast = DateUtil().totalLengthOfDays(dateLast.month, dateLast.day, dateLast.year);
    focus.countDaysFocus = countDayInit - countDayLast;
    return focus;
  }

  Future<NotificationRevo> getNotificationRandomDailyInit() async {
    ResponseApi<List<NotificationRevo>> responseApi = await FirebaseService().findAllNotificationDailyInit();
    if (responseApi.ok) {
      List<NotificationRevo> list = responseApi.result;
      return list[Random().nextInt(list.length)];
    }
  }

  Future<NotificationRevo> getNotificationRandomDailyFinish() async {
    ResponseApi<List<NotificationRevo>> responseApi = await FirebaseService().findAllNotificationDailyFinish();
    if (responseApi.ok) {
      List<NotificationRevo> list = responseApi.result;
      return list[Random().nextInt(list.length)];
    }
  }

  getSteps(context) async {
    ResponseApi<List<Dream>> responseApi = await FirebaseService().findAllDreams();

    List<Dream> listDream = responseApi.result;
    List<Widget> listChartWidget = List();
    List<StepDream> listAllStep = List();
    List<DailyGoal> listAllDailyGoal = List();

    if (listDream == null || listDream.isEmpty) {
      _addDreamStreamController.add(List<Dream>());
      NotificationUtil.deleteNotificationChannel(NotificationUtil.CHANNEL_NOTIFICATION_DAILY);
      NotificationUtil.deleteNotificationChannel(NotificationUtil.CHANNEL_NOTIFICATION_WEEKLY);
      return;
    }

    for (Dream dream in listDream) {
      List<StepDream> listStep = List();
      List<DailyGoal> listDailyGoals = List();

      if (dream != null && !dream.isDreamWait) {
        ResponseApi<CollectionReference> responseStepApi = FirebaseService().findSteps(dream);
        ResponseApi<CollectionReference> responseDailyApi = FirebaseService().findDailyGoals(dream);
        ResponseApi<List<DailyGoal>> responseHistApi = await FirebaseService()
            .findDailyGoalsCompletedHist(dream, Utils.resetStartDay(_currentDate), Utils.resetEndDay(_currentDate));
        List<DailyGoal> listHistDailyGoal = null;

        if (responseHistApi.ok) {
          listHistDailyGoal = responseHistApi.result;
        }

        if (responseStepApi.ok) {
          await loadSteps(responseStepApi, dream, listStep);
        }

        if (responseDailyApi.ok) {
          await loadDailyGoal(responseDailyApi, dream, listDailyGoals, listHistDailyGoal);
        }
      }
      listAllStep.addAll(listStep);
      listAllDailyGoal.addAll(listDailyGoals);
    }

    _addDreamStreamController.add(listDream);

    getStepChips(context, listAllStep);
    getDailyChips(context, listAllDailyGoal);

    if (listAllDailyGoal == null || listAllDailyGoal.isEmpty) {
      _addChartStreamController.add([Container()]);
    } else {
      List<List<ChartGoals>> listGoalsWeek = await getDataChartWeek(listDream); //zera isWonReward

      Widget chartWeek = ChartGoals.createChartWeek("Sua semana", listGoalsWeek);
      listChartWidget.add(chartWeek);

      _createBarMouth(listDream, listChartWidget);
      _addChartStreamController.add(listChartWidget);
    }

    controllerShowHistWeekMonth(listDream, context);
  }

  bool isHistWeekContainsDream(Dream dream, List<HistGoalWeek> listHist) {
    for (HistGoalWeek hist in listHist) {
      if (hist.dream.uid == dream.uid) {
        return true;
      }
    }
    return false;
  }

  controllerShowHistWeekMonth(List<Dream> listDream, context) async {
    DateTime lastHit = await FirebaseService().getLastHitUser();
    DateTime now = DateTime.now();
    DateTime firstDay = lastHit.subtract(Duration(days: lastHit.weekday));

    int qtdDayFirstDay = DateUtil().daysPastInYear(firstDay.month, firstDay.day, firstDay.year);
    int qtdDayNow = DateUtil().daysPastInYear(now.month, now.day, now.year);

    int nowWeek = Utils.getNumberWeek(now);
    int firstWeek = Utils.getNumberWeek(firstDay);

    bool isSunday = (qtdDayNow - qtdDayFirstDay) == 7;
    bool isChangeWeek = nowWeek.floor() != firstWeek.floor();

    bool isExistAcessLastMonth = await FirebaseService().isExistAcessPreviousMonth();
    DateTime dateLastAcess = await FirebaseService().getLastHitUser();

    int countAcess = await FirebaseService().getCountHitsUser();
    bool isUserMore7Days = countAcess > 7;

    if (isChangeWeek && isUserMore7Days) {
      List<HistGoalWeek> listHist = await findLastHistWeek(listDream);
      List<HistGoalWeek> listHistToday = await findLastShowHistWeekToday(listDream);

      if ((listHist == null || listHist.isEmpty) && (listHistToday == null || listHistToday.isEmpty)) {
        for (Dream dream in listDream) {
          if (!dream.isDreamWait) {
            HistGoalWeek histGoalWeek = await FirebaseService().saveHistWeekCompleted(dream, firstDay, false);
            listHist.add(histGoalWeek);
          }
        }
      } else if (listHistToday == null || listHistToday.isEmpty) {
        List<HistGoalWeek> listNewHist = new List();

        for (Dream dream in listDream) {
          if (!dream.isDreamWait && !isHistWeekContainsDream(dream, listHist)) {
            HistGoalWeek histGoalWeek = await FirebaseService().saveHistWeekCompleted(dream, firstDay, false);
            listHist.add(histGoalWeek);
          }
        }

        listHist.addAll(listNewHist);
      } else {
        listHist.clear();
      }

      if (listHist.isNotEmpty) {
        push(context, ReportDreamsWeek.from(listHist));
        listHist.forEach((hist) {
          FirebaseService().updateOnlyField("isShow", true, hist.reference);
          FirebaseService().updateOnlyField("dateLastShow", Timestamp.now(), hist.reference);
        });
      }
    }

    if (dateLastAcess != null && dateLastAcess.month != now.month && isExistAcessLastMonth) {
      List<HistGoalMonth> listHist = List();

      for (Dream dream in listDream) {
        ResponseApi<HistGoalMonth> responseApiMonth =
            await FirebaseService().findHistShowedForMonth(dream, dateLastAcess.month);
        if (!responseApiMonth.ok || responseApiMonth.result == null) {
          ResponseApi<HistGoalMonth> responseApi = await FirebaseService().findLastHistMonth(dream);
          if (!responseApi.ok || responseApi.result == null && !dream.isDreamWait) {
            FirebaseService().saveHistMonthCompleted(dream, now, dream.isGoalMonthOk);
          }
        }
      }

      for (Dream dream in listDream) {
        ResponseApi<HistGoalMonth> responseApi = await FirebaseService().findLastHistMonth(dream);
        if (responseApi.ok && responseApi.result != null) {
          listHist.add(responseApi.result);
        }
      }

      if (listHist.isNotEmpty) {
        push(context, ReportDreamsMonth.from(listHist));
        listHist.forEach((hist) {
          FirebaseService().updateOnlyField("isShow", true, hist.reference);
        });
      }
    }
  }

  Future loadSteps(ResponseApi<CollectionReference> responseStepApi, Dream dream, List<StepDream> listStep) async {
    QuerySnapshot querySnapshotSteps = await responseStepApi.result.orderBy("position").get();

    for (QueryDocumentSnapshot step in querySnapshotSteps.docs) {
      StepDream stepDream = StepDream.fromMap(step.data());
      stepDream.uid = step.id;
      stepDream.reference = step.reference;
      stepDream.dreamParent = dream;
      listStep.add(stepDream);
    }

    dream.steps = listStep;
  }

  Future loadDailyGoal(ResponseApi<CollectionReference> responseDailyApi, Dream dream, List<DailyGoal> listDailyGoals,
      List<DailyGoal> listHistDailyGoal) async {
    QuerySnapshot querySnapshotSteps = await responseDailyApi.result.orderBy("position").get();

    for (QueryDocumentSnapshot daily in querySnapshotSteps.docs) {
      DailyGoal dailyGoal = DailyGoal.fromMap(daily.data());
      dailyGoal.reference = daily.reference;
      dailyGoal.dreamParent = dream;
      if (listHistDailyGoal != null) {
        int index = listHistDailyGoal.indexWhere((hist) => hist.nameDailyGoal == dailyGoal.nameDailyGoal);
        dailyGoal.isHistCompletedDay = index >= 0;
      }
      listDailyGoals.add(dailyGoal);
    }

    dream.dailyGoals = listDailyGoals;
  }

  Future<List<HistGoalWeek>> findLastHistWeek(List<Dream> listDream) async {
    List<HistGoalWeek> listHist = List();
    for (Dream dream in listDream) {
      ResponseApi<HistGoalWeek> responseApi = await FirebaseService().findLastHistWeekWithDate(dream);
      if (responseApi.ok && responseApi.result != null) {
        listHist.add(responseApi.result);
      }
    }
    return listHist;
  }

  Future<List<HistGoalWeek>> findLastShowHistWeekToday(List<Dream> listDream) async {
    List<HistGoalWeek> listHist = List();
    for (Dream dream in listDream) {
      ResponseApi<HistGoalWeek> responseApi =
          await FirebaseService().findLastHistWeekWithDate(dream, date: Timestamp.now(), isShow: true);
      if (responseApi.ok && responseApi.result != null) {
        listHist.add(responseApi.result);
      }
    }
    return listHist;
  }

  Future<Widget> _createBarMouth(List<Dream> listDream, List<Widget> listChartWidget) async {
    var listGoals = await getDataChartJoin(listDream);
    int countBar = listGoals[0].length * listGoals.length;
    if (countBar > 15) {
      //TODO descobrir uma maneira melhor de contar as barras
      List<ChartGoals> listGoals = await getDataChartMouth(listDream);
      Widget chart = ChartGoals.createBarChartMouth(listGoals);
      listChartWidget.add(chart);
      _addChartStreamController.add(listChartWidget);
      return chart;
    } else {
      Widget chart = ChartGoals.createBarChartJoinMouth(listGoals);
      listChartWidget.add(chart);
      _addChartStreamController.add(listChartWidget);
      return chart;
    }
  }

  List<CardDream> getlistCardDream(BuildContext context) {
    List<CardDream> listCardDream = List<CardDream>();

    for (Dream dream in listDream) {
      CardDream cardDream = CardDream(
        color: dream.color,
        imgBase64: dream.imgDream,
        selected: false,
        onTap: () => _editDream(context, dream),
        title: dream.dreamPropose,
        subTitle: dream.descriptionPropose,
        isDreamWait: dream.isDreamWait,
      );

      listCardDream.add(cardDream);
    }

    return listCardDream;
  }

  List<CardDream> getlistCardDreamFire(BuildContext context, List<Dream> listDream) {
    List<CardDream> listCardDream = List<CardDream>();

    for (Dream dream in listDream) {
      CardDream cardDream = CardDream(
        color: dream.color,
        imgBase64: dream.imgDream,
        selected: false,
        onTap: () => _editDream(context, dream),
        title: dream.dreamPropose,
        isDreamWait: dream.isDreamWait,
        subTitle: dream.descriptionPropose,
      );

      listCardDream.add(cardDream);
    }

    listCardDream.add(CardDream(
      imageAsset: Utils.getPathAssetsImg("icon_add_dream.png"),
      selected: false,
      isCardAdd: true,
      onTap: () => _addDream(context),
      title: "Novo sonho",
    ));

    return listCardDream;
  }

  Future<List<Widget>> getStepChips(context, List<StepDream> steps) async {
    if (steps == null || steps.isEmpty) {
      _addChipStepsStreamController.add(
          [Container(margin: EdgeInsets.only(left: 12), child: TextUtil.textDefault("Etapas ainda não definidas"))]);
      return [];
    }

    List<Widget> listWidget = await verifyCheckChipStep(context, steps);
    _addChipStepsStreamController.add(listWidget);
    return listWidget;
  }

  Future<List<Widget>> getDailyChips(context, List<DailyGoal> dailys) async {
    if (dailys == null || dailys.isEmpty) {
      _addChipDailyStreamController.add(
          [Container(margin: EdgeInsets.only(left: 12), child: TextUtil.textDefault("Metas ainda não definidas"))]);
      return [];
    }
    List<Widget> listWidget = await verifyCheckChipDaily(context, dailys);
    _addChipDailyStreamController.add(listWidget);
    return listWidget;
  }

  Future verifyCheckChipStep(context, List<StepDream> steps) async {
    List<Widget> listWidget = List();

    for (StepDream stepDream in steps) {
      ChoiceChip chip = ChoiceChip(
        elevation: 8,
        label: TextUtil.textChipLight(stepDream.step),
        backgroundColor: Utils.colorFromHex(stepDream.dreamParent.color.primary),
        selectedColor: AppColors.colorPrimary,
        selected: stepDream.isCompleted,
        avatar: stepDream.isCompleted
            ? CircleAvatar(
                backgroundColor: AppColors.colorPrimaryDark,
                child: Icon(
                  Icons.check,
                  color: AppColors.colorlight,
                  size: 18,
                ),
              )
            : Icon(
                Icons.radio_button_unchecked,
                color: AppColors.colorlight,
              ),
        onSelected: (selected) {
          stepDream.isCompleted = selected;
          stepDream.dateCompleted = Timestamp.now();
          updatStepDream(context, stepDream, selected);
        },
      );

      listWidget.add(Container(margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }
    return listWidget;
  }

  int weekdayFirsdaySunday(int weekday) {
    if (weekday == 7) {
      return 1;
    } else {
      return weekday + 1;
    }
  }

  getDaysOfWeekRow(context) {
    List<Widget> listWidget = List();
    DateTime now = DateTime.now();
    DateTime firstDay = now.subtract(Duration(days: now.weekday));

    for (var i = 1; i <= 7; i++) {

      bool isdayEnable = i <= weekdayFirsdaySunday(now.weekday);
      DateTime dateWeek = firstDay.toLocal();
      bool isSelected = weekdayFirsdaySunday(_currentDate.weekday) == i;

      ChoiceChip chip = ChoiceChip(
        elevation: 2,
        visualDensity: VisualDensity.compact,
        label: TextUtil.textChipLight(firstDay.day.toString(), fontSize: 10),
        backgroundColor: isdayEnable ? AppColors.colorDark : AppColors.colorDisabled,
        selectedColor: AppColors.colorViolet,
        selected: isSelected,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onSelected: (selected) {
          if (isdayEnable) {
            selectDayOfWeek(context, dateWeek);
          }
        },
      );

      var borderSelected = BoxDecoration(
          border: Border.all(color: AppColors.colorEggShell, width: 1), borderRadius: BorderRadius.circular(30));
      var borderNormal = BoxDecoration();

      var dayContainer = Container(
        child: InkWell(
          onTap: () {
            if (isdayEnable) {
              selectDayOfWeek(context, dateWeek);
            }
          },
          child: Column(
            children: [TextUtil.textChipLight(Utils.weekday(firstDay.weekday, true), fontSize: 10), chip],
          ),
        ),
        padding: EdgeInsets.all(6),
        decoration: isSelected ? borderSelected : borderNormal,
      );

      listWidget.add(dayContainer);

      firstDay = firstDay.add(Duration(days: 1));
    }

    return listWidget;
  }

  void selectDayOfWeek(BuildContext context, DateTime date) {
    _currentDate = date;
    MainEventBus().get(context).sendEventHomeDream(TipoEvento.FETCH_WITH_LOADING);
  }

  void updatStepDream(context, StepDream stepDream, bool selected) async {
    showLoading(description: "Calculando etapas...");
    ResponseApi responseApi = await FirebaseService().updateStepDream(stepDream);
    hideLoading();
    MainEventBus().get(context).sendEventHomeDream(TipoEvento.FETCH);
  }

  Future verifyCheckChipDaily(context, List<DailyGoal> listDailyGoals) async {
    List<Widget> listWidget = List();

    for (DailyGoal daily in listDailyGoals) {
      ChoiceChip chip = ChoiceChip(
        elevation: 8,
        label: TextUtil.textChipLight(daily.nameDailyGoal),
        backgroundColor: Utils.colorFromHex(daily.dreamParent.color.primary),
        selectedColor: AppColors.colorPrimary,
        selected: daily.isHistCompletedDay,
        avatar: daily.isHistCompletedDay
            ? CircleAvatar(
                backgroundColor: AppColors.colorPrimaryDark,
                child: Icon(
                  Icons.check,
                  color: AppColors.colorlight,
                  size: 18,
                ),
              )
            : Icon(
                Icons.radio_button_unchecked,
                color: AppColors.colorlight,
              ),
        onSelected: (selected) {
          if (selected) {
            saveLastFocus();
          }
          daily.lastDateCompleted = selected ? Timestamp.fromDate(_currentDate) : null;
          updateDailyGoal(context, daily, selected);
        },
      );

      listWidget.add(Container(margin: EdgeInsets.only(left: 2, right: 2, top: 1), child: chip));
    }

    return listWidget;
  }

  Future updateDailyGoal(context, DailyGoal daily, bool selected) async {
    if (selected) {
      _showCheckSucessGoal(true);
    }

    await FirebaseService().updateDailyGoal(daily);

    if (selected) {
      Future.delayed(Duration(seconds: 2), () {
        _showCheckSucessGoal(false);
      });
    }

    MainEventBus().get(context).sendEventHomeDream(selected ? TipoEvento.FETCH : TipoEvento.FETCH_WITH_LOADING);
  }

  Future<List<List<ChartGoals>>> getDataChartWeek(List<Dream> listDream) async {
    List<List<ChartGoals>> listDataChartGoals = List();

    for (Dream dream in listDream) {
      if (dream.isDreamWait) {
        continue;
      }

      List<ChartGoals> listWeek = List();
      List<DailyGoal> listDaily = dream.dailyGoals;

      int maxStep = listDaily.length;
      int maxPointsWeek = 7 * maxStep;
      double percent = 0;

      DateTime now = DateTime.now();
      DateTime firstDay = now.subtract(Duration(days: now.weekday));

      int qtdDayFirstDay = DateUtil().daysPastInYear(firstDay.month, firstDay.day, firstDay.year);
      int qtdDayNow = DateUtil().daysPastInYear(now.month, now.day, now.year);

      //Verificar se é domingo, caso sim, a comparação tem que ser com o dia de hoje e não com o first
      bool isSunday = (qtdDayNow - qtdDayFirstDay) == 7;
      int progress = isSunday ? 1 : (qtdDayNow - qtdDayFirstDay) + 1;

      List<DailyGoal> listDailyOk = List();

      ResponseApi<List<DailyGoal>> responseApi =
          await FirebaseService().findDailyGoalsCompletedHist(dream, firstDay, now);
      if (responseApi.ok) {
        listDailyOk = responseApi.result;
      }

      for (int i = 1; i <= progress; i++) {
        int totalDaysOk = 0;

        for (DailyGoal daily in listDailyOk) {
          if (firstDay.day == daily.lastDateCompleted.toDate().day ||
              (isSunday && now.day == daily.lastDateCompleted.toDate().day)) {
            totalDaysOk++;
          }
        }

        if (totalDaysOk > 0) {
          percent = percent + (totalDaysOk / maxPointsWeek) * 100;
        }
        listWeek.add(ChartGoals(
            i.toDouble(), percent, Utils.colorFromHex(dream.color.primary), dream.goalWeek, dream.goalMonth));
        firstDay = firstDay.add(Duration(days: 1));
      }

      ChartGoals last = listWeek.last;
      bool lastIsGoalWeekOk = dream.isGoalWeekOk ? true : false;
      dream.isGoalWeekOk = last.percentStepCompleted >= dream.goalWeek;
      updateIsGoalWeek(dream, firstDay, lastIsGoalWeekOk);
      listDataChartGoals.add(listWeek);
    }

    return listDataChartGoals;
  }

  void updateIsGoalWeek(Dream dream, DateTime firstDay, bool lastIsGoalWeekOk) {
    FirebaseService().updateOnlyField("isGoalWeekOk", dream.isGoalWeekOk, dream.reference);
    if (!lastIsGoalWeekOk && dream.isGoalWeekOk) {
      FirebaseService().saveHistWeekCompleted(dream, firstDay, true);
    }
  }

  void updateIsGoalMonth(Dream dream, DateTime dateCompleted, bool lastIsGoalMonthOk) {
    FirebaseService().updateOnlyField("isGoalMonthOk", dream.isGoalMonthOk, dream.reference);
    if (!lastIsGoalMonthOk && dream.isGoalMonthOk) {
      FirebaseService().saveHistMonthCompleted(dream, dateCompleted, true);
    }
  }

  Future<List<ChartGoals>> getDataChartMouth(List<Dream> listDream) async {
    List<ChartGoals> listMouth = List();
    int maxStep = 0;

    listDream.forEach((dream) {
      if (!dream.isDreamWait) {
        maxStep = maxStep + dream.steps.length;
      }
    });

    double percent = 0;

    DateTime now = DateTime.now();
    DateTime firstMouth = DateTime(now.year, 1, 1);

    for (int i = 1; i <= now.month; i++) {
      int countDailyOk = 0;
      double countLevelWeek = 0;
      double countLevelMonth = 0;

      List<DailyGoal> listAllDaily = List();
      double mediaGoal = 0;

      for (Dream dream in listDream) {
        if (dream.isDreamWait) {
          continue;
        }
        ResponseApi<List<DailyGoal>> responseApi =
            await FirebaseService().findDailyGoalsCompletedHist(dream, firstMouth, now);
        if (responseApi.ok) {
          listAllDaily.addAll(responseApi.result);
        }
        countLevelMonth += dream.goalMonth;
        countLevelWeek += dream.goalWeek;
      }

      for (DailyGoal daily in listAllDaily) {
        if (daily.lastDateCompleted.toDate().month == firstMouth.month) {
          countDailyOk++;
        }
      }

      int dayInMouth = DateUtil().daysInMonth(i, firstMouth.year);
      int maxPointsMouth = dayInMouth * maxStep;

      if (countDailyOk > 0) {
        percent = (countDailyOk / maxPointsMouth) * 100;
      }
      listMouth.add(ChartGoals(i.toDouble(), percent, Colors.lightGreenAccent, (countLevelWeek / listDream.length),
          (countLevelMonth / listDream.length)));
      firstMouth = DateTime(firstMouth.year, firstMouth.month + 1, firstMouth.day);
    }

    return listMouth;
  }

  Future<List<List<ChartGoals>>> getDataChartJoin(List<Dream> listDream) async {
    List<List<ChartGoals>> listData = List();
    for (Dream dream in listDream) {
      if (dream.isDreamWait) {
        continue;
      }

      List<ChartGoals> listGoals = await _getDataChartForDreamMouth(dream);

      ChartGoals last = listGoals.last;
      bool lastIsGoalMonthOk = dream.isGoalMonthOk ? true : false;
      dream.isGoalMonthOk = last.percentStepCompleted >= dream.goalMonth;
      updateIsGoalMonth(dream, DateTime.now(), lastIsGoalMonthOk);

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
    ResponseApi<List<DailyGoal>> responseApi =
        await FirebaseService().findDailyGoalsCompletedHist(dream, firstMouth, now);
    if (responseApi.ok) {
      dailyGoals = responseApi.result;
    }

    for (int i = 1; i <= now.month; i++) {
      int maxStep = dream.dailyGoals.length;
      int dayInMouth = DateUtil().daysInMonth(i, firstMouth.year);
      int maxPointsMouth = dayInMouth * maxStep;

      int countDailyOk = 0;
      for (DailyGoal daily in dailyGoals) {
        if (firstMouth.month == daily.lastDateCompleted.toDate().month) {
          countDailyOk++;
        }
      }
      double percent = 0;

      if (countDailyOk > 0) {
        percent = (countDailyOk / maxPointsMouth) * 100;
      }
      listMouth.add(
          ChartGoals(i.toDouble(), percent, Utils.colorFromHex(dream.color.primary), dream.goalWeek, dream.goalMonth));
      firstMouth = DateTime(firstMouth.year, firstMouth.month + 1, firstMouth.day);
    }

    return listMouth;
  }

  _editDream(BuildContext context, Dream dream) async {
    RegisterDreamPage pageEdit = RegisterDreamPage(
      dream: dream,
    );
    push(context, pageEdit);
  }

  _addDream(BuildContext context) {
    // push(context, RegisterDreamPage());
    push(context, CheckTypeDreamPage());
  }

  _showCheckSucessGoal(bool isShow) {
    _addCheckSucessStreamController.sink.add(isShow);
  }

  Future<bool> isVisibilityStepPrefs(bool defaultValue) async {
    return Prefs.getBool("IS_VISIBILITY_STEP", defaultValue);
  }

  void setVisibilityStepPrefs(bool isVisible) async {
    Prefs.putBool("IS_VISIBILITY_STEP", isVisible);
  }
}

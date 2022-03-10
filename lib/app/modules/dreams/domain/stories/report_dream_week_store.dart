import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/period_report_dto.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/i_report_dream_case.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobx/mobx.dart';

part 'report_dream_week_store.g.dart';

class ReportDreamWeekStore = _ReportDreamWeekStoreBase with _$ReportDreamWeekStore;

abstract class _ReportDreamWeekStoreBase with Store {
  IReportDreamCase _reportDreamCase;
  IDreamCase _dreamCase;

  _ReportDreamWeekStoreBase(this._reportDreamCase, this._dreamCase);

  @observable
  bool isLoading = false;

  @observable
  String nameAnimation = "appear";

  @observable
  List<StatusDreamPeriod> listStatusDreamPeriod = ObservableList.of([]);

  @observable
  MessageAlert? msgAlert;

  PageController pageViewController = PageController();
  GlobalKey _globalKey = GlobalKey();

  Future<void> featch(BuildContext context, PeriodReportDto dto) async {
    isLoading = true;

    ResponseApi<List<Dream>> responseApi = await _dreamCase.findDreamsForUser();
    msgAlert = responseApi.messageAlert;
    if (responseApi.ok) {
      List<Dream> listDreamResult = responseApi.result!;
      List<StatusDreamPeriod> listStatusPeriod = [];

      for (Dream dream in listDreamResult) {

        if(dream.isDreamWait == true){
          continue;
        }

        dream.dailyGoals = await _findDailyGoalsWithDream(dream);
        dream.steps = await _findStepsWithDream(dream);
        StatusDreamPeriod period = await createStatusDreamPeriod(dream, dto);
        listStatusPeriod.add(period);

        if(dto.periodStatus == PeriodStatusDream.WEEKLY) {
          _reportDreamCase.saveStatusDreamWithWeek(period);
        }else{
          _reportDreamCase.saveStatusDreamWithMonth(period);
        }
      }
      
      listStatusDreamPeriod = ObservableList.of(listStatusPeriod);

    }

    isLoading = false;
  }

  Future<StatusDreamPeriod> createStatusDreamPeriod(Dream dream, PeriodReportDto dto) async {
    var difficulty = dream.goalWeek!;
    var percentCompleted = 0.0;
    bool isGoalOk = false;
    TypeStatusDream typeStatus = TypeStatusDream.INFLECTION;
    String? descriptionAction =  "";

    if(dto.periodStatus == PeriodStatusDream.WEEKLY){
      percentCompleted = await _calculatePercentCompletedWeek(dream); //OK
    }else{
      percentCompleted = await _calculatePercentCompletedMonth(dto.numPeriod, dto.year, dream);
    }

    if(percentCompleted >= difficulty){
      isGoalOk = true;
      typeStatus = TypeStatusDream.REWARD;
    }

    switch(typeStatus){
      case TypeStatusDream.INFLECTION: {
        if(dream.isInflectionWeek == true && dto.periodStatus == PeriodStatusDream.WEEKLY){
          descriptionAction = dream.inflectionWeek;
        }else{
          descriptionAction = dream.inflection;
        }
        break;
      }
      case TypeStatusDream.REWARD: {
        if(dream.isRewardWeek == true && dto.periodStatus == PeriodStatusDream.WEEKLY){
          descriptionAction = dream.rewardWeek;
        }else{
          descriptionAction = dream.reward;
        }
        break;
      }
    }

    StatusDreamPeriod period = StatusDreamPeriod(
      dream: dream,
      number: dto.numPeriod,
      year: dto.year,
      descriptionAction: descriptionAction,
      difficulty: difficulty,
      isChecked: false,
      periodStatusDream: dto.periodStatus,
      typeStatusDream: typeStatus,
      percentCompleted: percentCompleted
    );
    return period;
  }

  Future<double> _calculatePercentCompletedMonth(int month, int year, Dream dream) async {
    var daysInMonth = DateUtil().daysInMonth(month, year);
    var countDaily = dream.dailyGoals?.length??0;

    List<DailyGoal> listHistoryMonthDailyGoals = await _findHistoryLastMonthDailyGoal(dream, month, year);

    var countCompletedDailyHist = listHistoryMonthDailyGoals.length;
    return countCompletedDailyHist / (countDaily * daysInMonth);
  }

  Future<double> _calculatePercentCompletedWeek(Dream dream) async {
    List<DailyGoal> listHistoryWeekDailyGoals = await _findHistoryLastWeekDailyGoal(dream);
    dream.listHistoryWeekDailyGoals = listHistoryWeekDailyGoals;

    var daysWeek = 7;
    var countDaily = dream.dailyGoals?.length??0;
    var countCompletedDailyHist =  dream.listHistoryWeekDailyGoals?.length??0;

    return countCompletedDailyHist / (countDaily * daysWeek); //OK
  }

  Future<List<StepDream>> _findStepsWithDream(Dream dream) async {
    ResponseApi<List<StepDream>> responseApiStep = await _dreamCase.findStepDreamForUser(dream.uid!);
    msgAlert = responseApiStep.messageAlert;
    if (responseApiStep.ok) {
      return responseApiStep.result!;
    }
    return [];
  }

  Future<List<DailyGoal>> _findDailyGoalsWithDream(Dream dream) async {
     ResponseApi<List<DailyGoal>> responseApiDaily = await _dreamCase.findDailyGoalForUser(dream.uid!);
    msgAlert = responseApiDaily.messageAlert;
    if (responseApiDaily.ok) {
      return responseApiDaily.result!;
    }
    return [];
  }

  Future<List<DailyGoal>> _findHistoryLastWeekDailyGoal(Dream dream) async {

    if(dream.uid != null && dream.uid!.isNotEmpty){
      DateTime now = DateTime.now();
      DateTime dateLastWeek = now.subtract(Duration(days: now.weekday));
      ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findHistoryDailyGoalCurrentWeek(dream, dateLastWeek, isIgnoreSunday: true);
      msgAlert = responseApi.messageAlert;
      if(responseApi.ok){
        return  responseApi.result!;
      }
    }
    return [];
  }

  Future<List<DailyGoal>> _findHistoryLastMonthDailyGoal(Dream dream, int month, int year) async {
    if(dream.uid != null && dream.uid!.isNotEmpty){
      ResponseApi<List<DailyGoal>> responseApi = await _dreamCase.findHistoryDailyGoalCurrentMonth(dream, month, year);
      msgAlert = responseApi.messageAlert;
      if(responseApi.ok){
        return responseApi.result!;
      }
    }
    return [];
  }




  @action
  void setNameAnimation(String anim) {
    this.nameAnimation = anim;
  }

  Widget getPageReport(StatusDreamPeriod statusDreamWeek, Dream dream, BuildContext context) {
       return  Container(
          margin: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () => _capturePng(dream),
              child: Icon(
                Icons.share,
                color: AppColors.colorDark,
              ),
              elevation: 8,
            ),
          ),
        );
  }

  Future<Uint8List?> _capturePng(Dream? dream) async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await (image.toByteData(format: ImageByteFormat.png) as FutureOr<ByteData>);
      var pngBytes = byteData.buffer.asUint8List();
//      var bs64 = base64Encode(pngBytes);
      _shareImage(byteData, dream);
      // setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _shareImage(ByteData bytes, Dream? dream) async {
    // try {
    //   await  ShareFilesAndScreenshotWidgets().shareFile('Relatório do sonho', 'sonho_progresso.png',
    //       bytes.buffer.asUint8List(), 'image/png',
    //       text: 'Progresso do sonho ${dream.dreamPropose}');
    // } catch (e) {
    //   print('error: $e');
    // }
  }




}

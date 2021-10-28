import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/body_item_dream_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/week_calendar_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class DetailDreamPage extends StatefulWidget {

  final Dream dreamSelected;
  DetailDreamPage(this.dreamSelected);

  @override
  DetailDreamPageState createState() => DetailDreamPageState();
}

class DetailDreamPageState extends ModularState<DetailDreamPage, DetailDreamStore> {

  @override
  void initState() {
    super.initState();

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

    store.fetch(widget.dreamSelected);

  }

  getPage(){
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        new SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 230.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.passthrough,
                  alignment: Alignment.bottomLeft,
                children: [

                  Utils.string64ToImage(widget.dreamSelected.imgDream??"",
                      width: double.maxFinite, fit: BoxFit.cover),

                  Container(
                    decoration: AppColors.backgroundBoxDecorationImg(),
                  )
              ]
              ),
            ),
            title: TextUtil.textAppbar(widget.dreamSelected.dreamPropose??""),
            bottom: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 4),
                child: Observer(
                  builder: (context) => WeekCalendarWidget(
                    dateTimeSelectec: store.currentDate,
                    onTapDay: (DateTime dateSelected) {
                      store.changeCurrentDayForDailyGoal(widget.dreamSelected, dateSelected);
                    },
                  ),
                ),
              ),
              preferredSize: Size(double.infinity, 80),
            ),
        ),
      ];
    },
    body: body()
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:getPage(),
    );
  }

  ListView body() {
    return ListView(
      children: [
        Observer(
          builder: (context) {
            return BodyItemDreamWidget(
              listDailyGoal: store.listDailyGoals,
              listStepDream: store.listStep,
              listHistWeekDailyGoal: store.listHistoryWeekDailyGoals,
              listHistMonthDailyGoal: store.listHistoryYaerlyMonthDailyGoals,
              colorDream: widget.dreamSelected.color?.primary ?? "#BAF3BE",
              isChartWeek: store.isChartWeek,
              goalWeek: widget.dreamSelected.goalWeek??0,
              goalMonth: widget.dreamSelected.goalMonth??0,
              onTapSelectChart: (isChartWeek)  {
                store.changeTimeModeChart(widget.dreamSelected, isChartWeek);
              },
              onTapDailyGoal: (bool isSelected, DailyGoal dailyGoal) {
                store.updateDailyGoal(dailyGoal, isSelected);
              },
              onTapStep: (bool isSelected, StepDream step) {
                store.updateStepDream(step, isSelected);
              },
            );
          },
        ),

      ],
    );
  }
}

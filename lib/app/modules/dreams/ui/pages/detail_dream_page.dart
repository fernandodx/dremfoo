import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/button_appbar_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dtos/dream_page_dto.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/body_item_dream_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/week_calendar_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
              _navigationPopDreamPage(context);
            },),
            actions: [
              ButtonAppbarWidget(
                  labelButton: Translate.i().get.label_edit,
                  onTapButton: () {
                    store.editDream(context, widget.dreamSelected);
                  },
              ),
            ],
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

  void _navigationPopDreamPage(BuildContext context) {
      Dream dream = widget.dreamSelected;
      dream.dailyGoals = store.listDailyGoals;
      dream.steps = store.listStep;
      dream.listHistoryWeekDailyGoals = store.listHistoryWeekDailyGoals;
      dream.percentStep = store.percentStep;
      dream.percentToday = store.percentToday;
      dream.dateUpdate = store.dateUpdate;

      DreamPageDto _returnDreamDto = DreamPageDto(dream: dream);
      Navigator.pop(context, _returnDreamDto);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: getPage(),
        onWillPop: () async {
          _navigationPopDreamPage(context);
          return false;
        }
    );
    // return Scaffold(
    //   body:getPage(),
    // );
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
                store.updateDailyGoal(dailyGoal, isSelected, widget.dreamSelected);
              },
              onTapStep: (bool isSelected, StepDream step) {
                store.updateStepDream(step, isSelected, widget.dreamSelected);
              },
            );
          },
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChipButtonWidget(
              name: Translate.i().get.label_dream_realized,
              icon: FontAwesomeIcons.check,
              size: 81,
              onTap: () {
                alertBottomSheet(context,
                    msg: Translate.i().get.msg_question_dream_realized,
                    title: Translate.i().get.label_dream_realized,
                    nameButtonDefault: Translate.i().get.label_yes,
                    onTapDefaultButton: () {
                      store.realizedDream(context, widget.dreamSelected);
                    });
              },),
            ChipButtonWidget(
                name: Translate.i().get.label_file_dream,
                size: 81,
                icon: FontAwesomeIcons.archive,
                onTap: () {
                  alertBottomSheet(context,
                      msg: Translate.i().get.msg_question_file_dream,
                      title: Translate.i().get.label_file_dream,
                      nameButtonDefault: Translate.i().get.label_to_file,
                      onTapDefaultButton: () {
                        store.archiveDream(context, widget.dreamSelected);
                      });
                }
            ),
          ],
        ),
        SpaceWidget()
      ],
    );
  }
}

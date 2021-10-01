import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/body_item_dream_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  int weekdayFirsdaySunday(int weekday) {
    if (weekday == 7) {
      return 1;
    } else {
      return weekday + 1;
    }
  }

  void selectDayOfWeek(BuildContext context, DateTime date) {
    store.currentDate = date;
  }

  getDaysOfWeekRow(context) {
    List<Widget> listWidget = [];
    DateTime now = DateTime.now();
    DateTime firstDay = now.subtract(Duration(days: now.weekday));

    for (var i = 1; i <= 7; i++) {

      bool isdayEnable = i <= weekdayFirsdaySunday(now.weekday);
      DateTime dateWeek = firstDay.toLocal();
      bool isSelected = weekdayFirsdaySunday(store.currentDate.weekday) == i;

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

  getPage(){
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        new SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 250.0,
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
            title: TextUtil.textAppbar("Seu sonho"),
            bottom: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: getDaysOfWeekRow(context),
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
        SpaceWidget(),
        Observer(
          builder: (context) {
            return BodyItemDreamWidget(
              listDailyGoal: store.listDailyGoals,
              listStepDream: store.listStep,
              colorDream: widget.dreamSelected.color?.primary ?? "#BAF3BE",
              onTapDailyGoal: (bool isSelected, DailyGoal dailyGoal) {
                store.updateDailyGoal(dailyGoal, isSelected);
              },
              onTapStep: (bool isSelected, StepDream step) {
                store.updateStepDream(step, isSelected);
              },
              onTapHist: (){
                print("Hitorico");
              },
            );
          },
        ),

      ],
    );
  }
}

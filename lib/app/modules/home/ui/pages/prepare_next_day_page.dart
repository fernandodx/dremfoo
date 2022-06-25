import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/prepare_next_day_store.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../../core/ui/widgets/alert_bottom_sheet.dart';

class PrepareNextDayPage extends StatefulWidget {

  DateTime dateSelected;
  PrepareNextDayPage({required this.dateSelected});

  @override
  State<PrepareNextDayPage> createState() => _PrepareNextDayPageState();
}

class _PrepareNextDayPageState extends ModularState<PrepareNextDayPage, PrepareNextDayStore> {

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
      if (isLoading) {
        Overlay.of(context)!.insert(overlayLoading);
      } else {
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if (msgErro != null) {
        alertBottomSheet(context, msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });


  }


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: TextUtil.textAppbar(Translate.i().get.label_preparing_next_day),
    ),
    body: Container(
      margin: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SpaceWidget(),
            AppTextDefault(name: Translate.i().get.label_focus_day, maxLength:60, controller: store.focusDayTextController, icon: FontAwesomeIcons.bullseye),
            SpaceWidget(),
            Card(
              elevation: 4,
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextUtil.textTitulo(Translate.i().get.label_what_will_avoid_today),
                    SpaceWidget(),
                    AppTextDefault(name: Translate.i().get.label_will_avoid, maxLength: 40, controller: store.prevendDayTextController, icon: FontAwesomeIcons.ban,)
                  ],
                ),
              ),
            ),
            SpaceWidget(),
            Card(
              elevation: 4,
              child: Container(
                width: double.maxFinite,
                  padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextUtil.textTitulo("5 ${Translate.i().get.label_tasks_accomplish_today}"),
                    SpaceWidget(),
                    AppTextDefault(name: "1˚ ${Translate.i().get.label_task}", maxLength: 60, controller: store.task1TextController,),
                    AppTextDefault(name: "2˚ ${Translate.i().get.label_task}", maxLength: 60, controller: store.task2TextController,),
                    AppTextDefault(name: "3˚ ${Translate.i().get.label_task}", maxLength: 60, controller: store.task3TextController,),
                    AppTextDefault(name: "4˚ ${Translate.i().get.label_task}", maxLength: 60, controller: store.task4TextController,),
                    AppTextDefault(name: "5˚ ${Translate.i().get.label_task}", maxLength: 60, controller: store.task5TextController,),
                  ],
                ),
              ),
            ),
            SpaceWidget(),
            AppButtonDefault(
                onPressed: () => store.saveDayPrepared(context, widget.dateSelected),
                label:  Translate.i().get.label_save,
            )
          ],
        ),
      ),
    )
    );
  }
}

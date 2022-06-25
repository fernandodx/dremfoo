import 'package:dremfoo/app/modules/core/ui/widgets/button_outlined_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/circle_avatar_user_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/home/domain/entities/task_on_day.dart';
import 'package:dremfoo/app/modules/home/domain/stories/daily_planning_store.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/outline_button_with_image_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../../../utils/utils.dart';
import '../../../core/domain/entities/error_msg.dart';
import '../../../core/ui/widgets/alert_bottom_sheet.dart';
import '../../../core/ui/widgets/card_feature_only_users_subscriber_widget.dart';
import '../../domain/entities/daily_gratitude.dart';
import '../../domain/entities/prevent_on_day.dart';

class DailyPlanningPage extends StatefulWidget {
  const DailyPlanningPage({Key? key}) : super(key: key);

  @override
  State<DailyPlanningPage> createState() => _DailyPlanningPageState();
}

class _DailyPlanningPageState extends ModularState<DailyPlanningPage, DailyPlanningStore> {
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

    store.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar(Translate.i().get.label_my_day),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CardFeatureOnlyUsersSubscriberWidget(),
              Observer(
                builder: (context) => Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: store.backDayPlanning,
                        child: CircleAvatarUserRevoWidget(
                          icon: FontAwesomeIcons.arrowLeft,
                          size: 18,
                        )),
                    TextUtil.textTitulo(store.labelDatePlanning),
                    InkWell(
                        onTap: store.nextDayPlanning,
                        child: CircleAvatarUserRevoWidget(
                            icon: FontAwesomeIcons.arrowRight, size: 18)),
                  ],
                ),
              ),
              SpaceWidget(),
              Observer(builder: (context) =>
                  Visibility(
                    visible: store.planningDaily == null,
                    child: Card(
                      elevation: 4,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                Utils.getPathAssetsImg(
                                  "planning_daily.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            ListTile(leading: FaIcon(FontAwesomeIcons.calendarDays, color: Theme.of(context).canvasColor,), title: TextUtil.textSubTitle(Translate.i().get.msg_daily_planning_tools, align: TextAlign.justify),),
                            ListTile(leading: FaIcon(FontAwesomeIcons.flagCheckered, color: Theme.of(context).canvasColor,), title: TextUtil.textSubTitle(Translate.i().get.msg_daily_planning_preparing_day, align: TextAlign.justify),),
                            ListTile(leading: FaIcon(FontAwesomeIcons.clipboardCheck, color: Theme.of(context).canvasColor,), title: TextUtil.textSubTitle(Translate.i().get.msg_daily_planning_amount_proposed, align: TextAlign.justify),)
                          ],
                        ),
                      ),
                    ),
                  )
              ),
              Observer(
                builder: (context) => Visibility(
                  visible: store.listGratitude.isNotEmpty,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtil.textTitulo("${Translate.i().get.label_grateful_for}:"),
                          SpaceWidget(),
                          containerGratitude(listDailyGratitude: store.listGratitude)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SpaceWidget(),
              Observer(
                builder: (context) => Visibility(
                  visible: store.planningDaily?.prepareNextDay?.focusDay != null,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtil.textTitulo("${Translate.i().get.label_my_focus_day}:"),
                          SpaceWidget(),
                          ListTile(
                            title: TextUtil.textSubTitle(
                                store.planningDaily?.prepareNextDay?.focusDay ?? "-",
                                fontSize: 15),
                            leading: CircleAvatarUserRevoWidget(
                              icon: FontAwesomeIcons.bullseye,
                              size: 16,
                              radiusSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SpaceWidget(),
              Observer(
                builder: (context) => Visibility(
                  visible: store.listPrevent.isNotEmpty,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtil.textTitulo("${Translate.i().get.label_should_avoid}:"),
                          SpaceWidget(),
                          containerPrevents(listPrevents: store.listPrevent),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SpaceWidget(),
              Observer(
                builder: (context) => Visibility(
                  visible: store.listTask.isNotEmpty,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtil.textTitulo(Translate.i().get.label_task_the_day),
                          SpaceWidget(),
                          containerTasks(context: context, listTasks: store.listTask),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SpaceWidget(),
              Observer(
                builder: (context) => Visibility(
                  visible: store.isShowAnalysisDay,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextUtil.textTitulo(Translate.i().get.label_analysis_that_day),
                          SpaceWidget(),
                          Divider(
                            height: 4,
                          ),
                          SpaceWidget(),
                          TextUtil.textSubTitle(
                            Translate.i().get.label_how_was_your_day,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.faceFrown,
                                color: Theme.of(context).canvasColor,
                              ),
                              Expanded(
                                child: Slider(
                                  value: store.planningDaily?.rateDayPlanning?.rateDay ?? 0,
                                  onChanged: (value) => print(value),
                                  max: 10,
                                  divisions: 10,
                                  label: "${store.planningDaily?.rateDayPlanning?.rateDay ?? 0}",
                                ),
                              ),
                              FaIcon(
                                FontAwesomeIcons.faceSmile,
                                color: Theme.of(context).canvasColor,
                              ),
                            ],
                          ),
                          SpaceWidget(),
                          TextUtil.textSubTitle(
                            Translate.i().get.label_how_was_learning_level,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.thumbsDown,
                                color: Theme.of(context).canvasColor,
                              ),
                              Expanded(
                                child: Slider(
                                  value:
                                      store.planningDaily?.rateDayPlanning?.levelLearningDay ?? 0,
                                  onChanged: (value) => print(value),
                                  max: 10,
                                  divisions: 10,
                                  label:
                                      "${store.planningDaily?.rateDayPlanning?.levelLearningDay ?? 0}",
                                ),
                              ),
                              FaIcon(
                                FontAwesomeIcons.thumbsUp,
                                color: Theme.of(context).canvasColor,
                              ),
                            ],
                          ),
                          ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.message,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: TextUtil.textSubTitle(
                                store.planningDaily?.rateDayPlanning?.commentLearningDaily ?? ""),
                          )
                        ],
                      ),
                    ),
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
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtil.textTitulo(
                        Translate.i().get.label_daily_planning,
                      ),
                      SpaceWidget(),
                      Divider(
                        height: 4,
                      ),
                      SpaceWidget(),
                      Observer(
                        builder: (context) => ChipButtonWidget(
                          name: store.getLabelRateDay(),
                          icon: FontAwesomeIcons.listCheck,
                          size: 200,
                          fontSize: 15,
                          onTap: () => Navigator.pushNamed(context, "/home/rateOfTheDay",
                              arguments: store.getDateForPrepareNextDayAndRateDay()),
                        ),
                      ),
                      SpaceWidget(),
                      Observer(
                        builder: (context) => ChipButtonWidget(
                          name: store.getLabelPrepareNextDay(),
                          icon: FontAwesomeIcons.arrowRotateRight,
                          size: 200,
                          fontSize: 15,
                          onTap: () {
                            Navigator.pushNamed(context, "/home/prepareNextDay",
                                arguments: store.getDateForPrepareNextDayAndRateDay());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Wrap containerPrevents({required List<PreventOnDay> listPrevents}) {
    var listTiles = listPrevents
        .map((prevent) => ListTile(
              title: TextUtil.textSubTitle(prevent.prevent ?? "-",
                  align: TextAlign.justify, fontSize: 15),
              leading: CircleAvatarUserRevoWidget(
                icon: FontAwesomeIcons.ban,
                size: 16,
                radiusSize: 15,
              ),
            ))
        .toList();

    return Wrap(children: listTiles);
  }

  Wrap containerTasks({required BuildContext context, required List<TaskOnDay> listTasks}) {
    var listTiles = listTasks
        .map(
          (task) => CheckboxListTile(
              activeColor: Theme.of(context).canvasColor,
              onChanged: (bool? value) => store.onUpdateListTask(value ?? false, task),
              value: task.isChecked(),
              title: TextUtil.textSubTitle(task.task ?? "-", fontSize: 15)),
        )
        .toList();

    return Wrap(children: listTiles);
  }

  Wrap containerGratitude({required List<DailyGratitude> listDailyGratitude}) {
    var listTiles = listDailyGratitude
        .map((gratitude) => ListTile(
              title: TextUtil.textSubTitle(gratitude.gratitude ?? "-",
                  align: TextAlign.justify, fontSize: 15),
              leading: CircleAvatarUserRevoWidget(
                icon: FontAwesomeIcons.handHoldingHeart,
                size: 16,
                radiusSize: 15,
              ),
            ))
        .toList();

    return Wrap(children: listTiles);
  }
}

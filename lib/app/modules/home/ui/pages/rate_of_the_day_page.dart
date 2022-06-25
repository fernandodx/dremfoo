import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/appbar_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/rate_of_the_day_store.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_button_default.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../../core/ui/widgets/alert_bottom_sheet.dart';

class RateOfTheDayPage extends StatefulWidget {

  DateTime dateSelected;
  RateOfTheDayPage({required this.dateSelected});

  @override
  State<RateOfTheDayPage> createState() => _RateOfTheDayPageState();
}

class _RateOfTheDayPageState extends ModularState<RateOfTheDayPage, RateOfTheDayStore> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar(Translate.i().get.label_rate_of_the_day),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                elevation: 4,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextUtil.textTitulo(Translate.i().get.label_how_was_your_day),
                      SpaceWidget(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FaIcon(FontAwesomeIcons.faceFrown, color: Theme.of(context).canvasColor,),
                          Observer(
                            builder: (context) => Expanded(
                              child: Slider(
                                thumbColor: Theme.of(context).canvasColor,
                                value: store.currentValueRateDay,
                                onChanged: (value) => store.setCurrentValueRateDay(value),
                                max: 10,
                                divisions: 10,
                                label: "${store.currentValueRateDay.round()}",
                              ),
                            ),
                          ),
                          FaIcon(FontAwesomeIcons.faceSmile, color: Theme.of(context).canvasColor,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SpaceWidget(),
              Card(
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      TextUtil.textTitulo(Translate.i().get.label_how_was_learning_level),
                      SpaceWidget(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FaIcon(FontAwesomeIcons.thumbsDown, color: Theme.of(context).canvasColor,),
                          Observer(
                            builder: (context) =>  Expanded(
                              child: Slider(
                                thumbColor: Theme.of(context).canvasColor,
                                value: store.levelLearning,
                                onChanged: (value) => store.setLevelLearning(value),
                                max: 10,
                                divisions: 10,
                                label: "${store.levelLearning.round()}",
                              ),
                            ),
                          ),
                          FaIcon(FontAwesomeIcons.thumbsUp, color: Theme.of(context).canvasColor,),
                        ],
                      ),
                      SpaceWidget(),
                      AppTextDefault(name: Translate.i().get.label_comment, maxLength: 80, controller: store.commentTextController,)
                    ],
                  ),
                ),
              ),
              SpaceWidget(),
              Card(
                elevation: 4,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextUtil.textTitulo(Translate.i().get.label_3_gratitude_day),
                      SpaceWidget(),
                      AppTextDefault(name: "1˚ ${Translate.i().get.label_grateful_for}", maxLength: 60, controller: store.gratitude1TextController,),
                      AppTextDefault(name: "2˚ ${Translate.i().get.label_grateful_for}", maxLength: 60, controller: store.gratitude2TextController,),
                      AppTextDefault(name: "3˚ ${Translate.i().get.label_grateful_for}", maxLength: 60, controller: store.gratitude3TextController,),
                    ],
                  ),
                ),
              ),
              SpaceWidget(),
              AppButtonDefault(label: Translate.i().get.label_save, onPressed: () => store.saveRateDay(widget.dateSelected),),
            ],
          ),
        ),
      ),
    );
  }
}

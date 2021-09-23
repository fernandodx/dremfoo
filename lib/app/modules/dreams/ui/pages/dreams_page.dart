import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dream_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/list_dream_widget.dart';
import 'package:dremfoo/app/widget/alert_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class DreamsPage extends StatefulWidget {

  @override
  DreamsPageState createState() => DreamsPageState();
}

class DreamsPageState extends ModularState<DreamsPage, DreamStore>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  bool isVisible = true;
   List<Dream> listDream = [];
  Map<Dream, bool> isVisibleBodyDreamMap = {};

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


    store.fetch();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Observer(
            builder: (context) => ListDreamWidget(
                listDream: store.listDream,
                listStepDream: [],
                listDailyGoal: [],
                controller: _controller,
                onTapDailyGoal: (bool isSelected, DailyGoal dailyGoal) {
                  print("$isSelected ${dailyGoal.toString()}");
                },
                onTapStep: (bool isSelected, StepDream step) {
                  print("$isSelected ${step.toString()}");
                },
                onTapExpansionPanel: (bool isOk, Dream dream) {
                  setState(() {
                    print("${dream.toString()} $isOk");
                    if (isVisible) {
                      isVisible = false;
                      isVisibleBodyDreamMap[dream] = false;
                      _controller.forward();
                    } else {
                      isVisible = true;
                      isVisibleBodyDreamMap[dream] = true;
                      _controller.reverse();
                    }
                  });
                },
                onTapHist: (){
                  print("Hitorico");
                },
                isVisibleBodyDreamMap: isVisibleBodyDreamMap,
                onTapConfigDream: (Dream dream) {
                  print("onTapConfigDream");
                },

            ),
          ),
        ),
    );
  }

}

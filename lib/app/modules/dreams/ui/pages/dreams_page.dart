import 'package:dremfoo/app/modules/core/ui/widgets/button_outlined_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dreams_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/body_item_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/daily_goals_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/header_item_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/list_dream_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/panel_info_dream_expansion_header_widget.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/steps_dream_widget.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class DreamsPage extends StatefulWidget {
  final String title;

  const DreamsPage({Key? key, this.title = 'DreamsPage'}) : super(key: key);

  @override
  DreamsPageState createState() => DreamsPageState();
}

class DreamsPageState extends ModularState<DreamsPage, DreamsStore>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controllerPhotoAnim = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -1.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  late final Animation<double> _animation =
      Tween(begin: 1.0, end: 0.0).animate(_controller);

  late final Animation<double> _animationRotation =
      Tween(begin: 0.0, end: 0.5).animate(_controller);

  bool isVisible = true;
  List<Dream> listDream = [];
  Map<Dream, bool> isVisibleBodyDreamMap = {};

  @override
  void initState() {
    super.initState();

    for(var i=0; i<=5; i++){
      var d = Dream();
      d.uid = "#$i";
      d.dreamPropose = "Meu sonho $i";
      d.descriptionPropose = "Descrição do Sonho que vai ser realizado com certeza vamos conseguir $i";
      listDream.add(d);
      isVisibleBodyDreamMap[d] = false;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListDreamWidget(
            listDream: listDream,
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
    );
  }

}

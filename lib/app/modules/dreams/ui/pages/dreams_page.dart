import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dreams_store.dart';
import 'package:dremfoo/app/modules/dreams/ui/widgets/list_dream_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamsPage extends StatefulWidget {
  final String title;

  const DreamsPage({Key? key, this.title = 'DreamsPage'}) : super(key: key);

  @override
  DreamsPageState createState() => DreamsPageState();
}

class DreamsPageState extends ModularState<DreamsPage, DreamsStore>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  bool isVisible = true;
  // List<Dream> listDream = [];
  Map<Dream, bool> isVisibleBodyDreamMap = {};

  @override
  void initState() {
    super.initState();
    store.fetchListDream();
    
    
    //
    // for(var i=0; i<=5; i++){
    //   var d = Dream();
    //   d.uid = "#$i";
    //   d.dreamPropose = "Meu sonho $i";
    //   d.descriptionPropose = "Descrição do Sonho que vai ser realizado com certeza vamos conseguir $i";
    //   listDream.add(d);
    //   isVisibleBodyDreamMap[d] = false;
    // }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Observer(
            builder: (context) => ListDreamWidget(
                listDream: store.listDream,
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

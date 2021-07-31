import 'package:dremfoo/app/model/hist_goal_month.dart';
import 'package:mobx/mobx.dart';

part 'report_dreams_month_model.g.dart';

class ReportDreamsMonthModel = ReportDreamsMonthModelBase with _$ReportDreamsMonthModel;

abstract class ReportDreamsMonthModelBase with Store {

  @observable
  String? nameAnimation;

  @action
  choiceAnimation(HistGoalMonth hist) {
    if(hist.isWonReward!){
      this.nameAnimation = "appear";
    }else{
      this.nameAnimation = "crying";
    }
  }
}
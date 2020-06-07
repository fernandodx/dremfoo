import 'package:cloud_firestore/cloud_firestore.dart';

class DailyGoal {

  String uid;
  String nameDailyGoal;
  String descriptionDailyGoal;
  int position;
  Timestamp lastDateCompleted;
  DocumentReference reference;

//  Set<StatusDream> statusDream = Set();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['nameDailyGoal'] = this.nameDailyGoal;
    data['descriptionDailyGoal'] = this.descriptionDailyGoal;
    data['position'] = this.position;
    data['lastDateCompleted'] = this.lastDateCompleted;

//    data['statusDream'] = this.statusDream;
    return data;
  }

  static DailyGoal fromMap(data){
    DailyGoal status = DailyGoal();
    status.uid = data['uid'];
    status.nameDailyGoal = data['nameDailyGoal'];
    status.position = data['position'];
    status.descriptionDailyGoal = data['descriptionDailyGoal'];
    status.lastDateCompleted = data['lastDateCompleted'];
    return status;
  }

  bool isCompletedToday(){

    if(lastDateCompleted == null){
      return false;
    }
    DateTime dateCompleted = lastDateCompleted.toDate();
    DateTime dateNow = DateTime.now();
    if(dateNow.day == dateCompleted.day
      && dateNow.month == dateCompleted.month
      && dateNow.year == dateCompleted.year){
      return true;
    }

    return false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DailyGoal &&
              runtimeType == other.runtimeType &&
              nameDailyGoal == other.nameDailyGoal;

  @override
  int get hashCode => nameDailyGoal.hashCode;






}
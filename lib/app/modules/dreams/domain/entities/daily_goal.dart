import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/model/dream.dart';
import 'package:dremfoo/app/api/extensions/util_extensions.dart';

class DailyGoal {

  String? uid;
  String? nameDailyGoal;
  String? descriptionDailyGoal;
  int? position;
  Timestamp? lastDateCompleted;
  late Dream dreamParent;
  late DocumentReference reference;
  bool? isHistCompletedDay;

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

  static List<DailyGoal> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      DailyGoal dailyGoal = fromMap(snapshot.data());
      dailyGoal.reference = snapshot.reference;
      dailyGoal.uid = snapshot.id;
      return dailyGoal;
    }).toList();
  }

  bool isCompletedToday(){

    if(lastDateCompleted == null){
      return false;
    }

    if(isHistCompletedDay != null) {
      return isHistCompletedDay!;
    }

    DateTime dateCompleted = lastDateCompleted!.toDate();
    DateTime dateNow = DateTime.now();
    return dateCompleted.isSameDate(dateNow);
  }

  bool isCompletedInDate(DateTime dateTime){
    if(isHistCompletedDay != null) {
      return isHistCompletedDay!;
    }

    if(lastDateCompleted == null){
      return false;
    }

    DateTime dateCompleted = lastDateCompleted!.toDate();
    return dateCompleted.isSameDate(dateTime);
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
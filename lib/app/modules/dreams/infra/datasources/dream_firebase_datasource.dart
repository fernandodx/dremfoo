import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/contract/idream_datasource.dart';

class DreamFirebaseDatasource extends BaseDataSource implements IDreamDatasource {
  @override
  Future<List<Dream>> findAllDreamForUser(String userUid) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    QuerySnapshot querySnapshot = await refUsers
        .collection("dreams")
        .where("isDeleted", isEqualTo: false)
        .where("dateFinish", isNull: true)
        .get()
        .catchError(handlerError);

    return Dream.fromListDocumentSnapshot(querySnapshot.docs);
  }

  Future<List<StepDream>> findAllStepsForDream(
      String userUid, String uidDream) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);

    QuerySnapshot querySnapshot = await refUsers
        .collection("dreams")
        .doc(uidDream)
        .collection("steps")
        .orderBy("position")
        .get()
        .catchError(handlerError);

    return StepDream.fromListDocumentSnapshot(querySnapshot.docs);
  }

  Future<List<DailyGoal>> findAllDailyGoalForDream(
      String userUid, String uidDream) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);

    QuerySnapshot querySnapshot = await refUsers
        .collection("dreams")
        .doc(uidDream)
        .collection("dailyGoals")
        .orderBy("position")
        .get()
        .catchError(handlerError);

    return DailyGoal.fromListDocumentSnapshot(querySnapshot.docs);
  }

  Future<void> updateDailyGoal(DailyGoal dailyGoal) async {
    DocumentReference dailyRef = dailyGoal.reference;
    dailyGoal.uid = dailyRef.id;
    dailyRef.set(dailyGoal.toMap()).catchError(handlerError);
  }

  Future<void> registerHistoryDailyGoal(DailyGoal dailyGoal) async {
    DocumentReference dailyRef = dailyGoal.reference;
    DocumentReference dreamRef = dailyRef.parent.parent!;
    CollectionReference histRef = dreamRef.collection("dailyCompletedHist");
    histRef.add(dailyGoal.toMap()).catchError(handlerError);
  }

  Future<void> deleteRegisterHistoryDailyGoalforDate(DailyGoal dailyGoal, DateTime dateDelete) async {
    DocumentReference dailyRef = dailyGoal.reference;
    DocumentReference dreamRef = dailyRef.parent.parent!;
    CollectionReference histRef = dreamRef.collection("dailyCompletedHist");

    // String dateStr = "${dateDelete.year}-${Utils.addZeroLeft(dateDelete.month)}-${Utils.addZeroLeft(dateDelete.day)}";
    // DateTime date = Utils.stringToDate(dateStr);
    DateTime dateStart = Utils.resetStartDay(dateDelete);
    DateTime dateEnd = Utils.resetEndDay(dateDelete);
    QuerySnapshot query = await histRef
                                .where("uid", isEqualTo: dailyGoal.uid)
                                .where("lastDateCompleted", isGreaterThanOrEqualTo: Timestamp.fromDate(dateStart))
                                .where("lastDateCompleted", isLessThanOrEqualTo: Timestamp.fromDate(dateEnd))
                                .get();
    for (QueryDocumentSnapshot snapshot in query.docs) {
      if (snapshot.exists) {
        snapshot.reference.delete().catchError(handlerError);
      }
    }
  }

  Future<void> updateStepDream(StepDream stepDream) async {
    DocumentReference stepUpdate = stepDream.reference;
    stepUpdate.set(stepDream.toMap()).catchError(handlerError);
  }

  Future<List<DailyGoal>> findIntervalHistoryDailyGoal(Dream dream, Timestamp dateStart, Timestamp dateEnd) async {
    DocumentReference dreamRef = dream.reference!;

    QuerySnapshot query = await dreamRef
        .collection("dailyCompletedHist")
        .where("lastDateCompleted", isGreaterThanOrEqualTo: dateStart)
        .where("lastDateCompleted", isLessThanOrEqualTo: dateEnd)
        .get()
        .catchError(handlerError);

    return DailyGoal.fromListDocumentSnapshot(query.docs);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/contract/idream_datasource.dart';
import 'package:flutter/widgets.dart';

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

  Future<List<DailyGoal>> findAllDailyGoalForDream(String userUid, String uidDream) async {
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

  @override
  Future<List<ColorDream>> findAllColorsDream() async  {
    QuerySnapshot querySnapshot = await firestore
        .collection("colorsDreams")
        .get()
        .catchError(handlerError);
    return  ColorDream.fromListDocumentSnapshot(querySnapshot.docs);
  }

  void _addRemoveDailyGoalsDream(Transaction transaction, QuerySnapshot queryDaily, List<DailyGoal> dailysOld, Dream dream, CollectionReference dailyGoalRef) {
     for (QueryDocumentSnapshot dailyOld in queryDaily.docs) {
      DailyGoal daily = DailyGoal.fromMap(dailyOld.data());
      daily.reference = dailyOld.reference;

      dailysOld.add(daily);
      if (!dream.dailyGoals!.contains(daily)) {
        transaction.delete(daily.reference);
      }
    }

    for (DailyGoal dailyGoal in dream.dailyGoals!) {
      if (!dailysOld.contains(dailyGoal)) {
        dailyGoalRef.add(dailyGoal.toMap());
      } else {
        int index = dailysOld.indexOf(dailyGoal);

        DailyGoal dailyCurrent = dailysOld[index];
        dailyCurrent.position = dailyGoal.position;
        transaction.set( dailyCurrent.reference, dailyCurrent.toMap());
      }
    }
  }

  void _addRemoveStepDream(Transaction transaction, QuerySnapshot queryStep, List<StepDream> stepsOld, Dream dream, CollectionReference stepsListRef) {
     for (QueryDocumentSnapshot stepOld in queryStep.docs) {
      StepDream step = StepDream.fromMap(stepOld.data());
      step.reference = stepOld.reference;

      stepsOld.add(step);
      if (!dream.steps!.contains(step)) {
        transaction.delete(step.reference);
      }
    }

    for (StepDream stepDream in dream.steps!) {
      if (!stepsOld.contains(stepDream)) {
        stepsListRef.add(stepDream.toMap());
      } else {
        int index = stepsOld.indexOf(stepDream);

        StepDream dreamCurrent = stepsOld[index];
        dreamCurrent.position = stepDream.position;
        transaction.set(dreamCurrent.reference, dreamCurrent.toMap());
      }
    }
  }

  @override
  Future<Dream> saveDream(Dream dream, String userUid) async {

    DocumentReference refUsers = getRefCurrentUser(userUid);

    DocumentReference dreamRef = await refUsers.collection("dreams")
        .add(dream.toMap())
        .catchError(handlerError);

    if(dream.steps != null) {
      CollectionReference stepsListRef = dreamRef.collection("steps");
      for (StepDream stepDream in dream.steps!) {
        stepsListRef.add(stepDream.toMap());
      }
    }

    if(dream.dailyGoals != null) {
      CollectionReference dailyGoalRef = dreamRef.collection("dailyGoals");
      for (DailyGoal dailyGoal in dream.dailyGoals!) {
        dailyGoalRef.add(dailyGoal.toMap());
      }
    }
    dream.reference = dreamRef;
    return dream;
  }

  @override
  Future<Dream> updatePercentsGoalsDream(Dream dream) async {
    DocumentReference dreamRef = dream.reference!;
    dreamRef.update({
      "percentStep" : dream.percentStep,
      "percentToday" : dream.percentToday,
      "dateUpdate": Timestamp.now()
    }).catchError(handlerError);
    return dream;
  }


  @override
  Future<Dream> updateDream(Dream dream) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {

      DocumentReference dreamRef = dream.reference!;
      transaction.update(dreamRef, dream.toMap());

      CollectionReference stepsListRef = dreamRef.collection("steps");
      CollectionReference dailyGoalRef = dreamRef.collection("dailyGoals");

      QuerySnapshot queryStep = await stepsListRef.get();
      QuerySnapshot queryDaily = await dailyGoalRef.get();

      List<StepDream> stepsOld = [];
      List<DailyGoal> dailysOld = [];

      _addRemoveStepDream(transaction, queryStep, stepsOld, dream, stepsListRef);
      _addRemoveDailyGoalsDream(transaction, queryDaily, dailysOld, dream, dailyGoalRef);

    }).catchError(handlerError);
    return dream;
  }

  @override
  Future<List<Dream>> findAllDreamsArchive(String uidUser) async {
      DocumentReference refUsers = getRefCurrentUser(uidUser);
      QuerySnapshot querySnapshot = await refUsers
          .collection("dreams")
          .where("isDeleted", isEqualTo: true)
          .get()
          .catchError(handlerError);
      return Dream.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<void> updateOnlyFieldDream(Dream dream, String field, dynamic value) async {
    DocumentReference dreamRef = dream.reference!;
    dreamRef.update({field: value}).catchError(handlerError);
  }

  @override
  Future<List<Dream>> findAllDreamsCompleted(String uidUser) async {
      DocumentReference refUsers = getRefCurrentUser(uidUser);

      QuerySnapshot querySnapshot = await refUsers
          .collection("dreams")
          .where("dateFinish", isLessThanOrEqualTo: Timestamp.now())
          .get()
          .catchError(handlerError);

      return Dream.fromListDocumentSnapshot(querySnapshot.docs);
  }

}

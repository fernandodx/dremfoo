import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<StepDream>> findAllStepsForDream(String userUid, String uidDream) async {

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



}
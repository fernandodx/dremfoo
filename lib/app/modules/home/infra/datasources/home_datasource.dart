import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';
import 'package:dremfoo/app/modules/home/domain/entities/daily_gratitude.dart';
import 'package:dremfoo/app/modules/home/domain/entities/planning_daily.dart';
import 'package:dremfoo/app/modules/home/domain/entities/prevent_on_day.dart';
import 'package:dremfoo/app/modules/home/domain/entities/rate_day_planning.dart';
import 'package:dremfoo/app/modules/home/domain/entities/task_on_day.dart';
import 'package:dremfoo/app/modules/home/domain/entities/test_free_feature.dart';
import 'package:dremfoo/app/utils/utils.dart';

import 'contract/ihome_datasource.dart';

class HomeDataSource extends BaseDataSource implements IHomeDatasource {
  @override
  Future<List<Video>> findAllVideos(bool descending) async {
    QuerySnapshot querySnapshot =
        await firestore.collection("videos").orderBy("date", descending: descending).get();
    return Video.fromListDocumentSnapshot(querySnapshot.docs);
  }

  Future<PlanningDaily> saveOrUpdateRateDayForPlanningDaily(
      String userUid, PlanningDaily planningDaily) async {
    Timestamp date = planningDaily.date!;
    DateTime dateStart = Utils.resetStartDay(date.toDate());
    DateTime dateEnd = Utils.resetEndDay(date.toDate());

    List<PlanningDaily> listPlannig = await findDailyPlaningForDate(
        userUid, Timestamp.fromDate(dateStart), Timestamp.fromDate(dateEnd));
    if (listPlannig.isEmpty) {
      DocumentReference refUsers = getRefCurrentUser(userUid);
      DocumentReference planningRef = await refUsers
          .collection("dailyPlanning")
          .add(planningDaily.toMap())
          .catchError(handlerError);

      planningDaily.listGraditude?.forEach((dailyGratitude) {
        planningRef
            .collection("listDailyGratitude")
            .add(dailyGratitude.toMap())
            .catchError(handlerError);
      });

      planningDaily.reference = planningRef;
    } else {
      PlanningDaily planningDailyUpdate = listPlannig.first;
      await planningDailyUpdate.reference?.update({
        "rateDayPlanning": planningDaily.rateDayPlanning?.toMap(),
      }).catchError(handlerError);

      var listDailyRef =
          await planningDailyUpdate.reference?.collection("listDailyGratitude").get();

      if (listDailyRef != null) {
        for (QueryDocumentSnapshot dailyGratitude in listDailyRef.docs) {
          dailyGratitude.reference.delete();
        }

        planningDaily.listGraditude?.forEach((dailyGratitude) {
          planningDailyUpdate.reference
              ?.collection("listDailyGratitude")
              .add(dailyGratitude.toMap())
              .catchError(handlerError);
        });
      }
      planningDaily.reference = planningDailyUpdate.reference;
    }
    return planningDaily;
  }

  @override
  Future<PlanningDaily> saveOrUpdatePrepareNextDayForPlanningDaily(
      String userUid, PlanningDaily planningDaily) async {
    Timestamp date = planningDaily.date!;
    DateTime dateStart = Utils.resetStartDay(date.toDate());
    DateTime dateEnd = Utils.resetEndDay(date.toDate());

    List<PlanningDaily> listPlannig = await findDailyPlaningForDate(
        userUid, Timestamp.fromDate(dateStart), Timestamp.fromDate(dateEnd));
    if (listPlannig.isEmpty) {
      DocumentReference refUsers = getRefCurrentUser(userUid);
      DocumentReference planningRef = await refUsers
          .collection("dailyPlanning")
          .add(planningDaily.toMap())
          .catchError(handlerError);

      planningDaily.listTaskDay?.forEach((taskDay) {
        planningRef.collection("listTaskDay").add(taskDay.toMap()).catchError(handlerError);
      });

      planningDaily.listPreventDay?.forEach((preventDay) {
        planningRef.collection("listPreventDay").add(preventDay.toMap()).catchError(handlerError);
      });

      planningDaily.reference = planningRef;
    } else {
      PlanningDaily planningDailyUpdate = listPlannig.first;
      await planningDailyUpdate.reference?.update({
        "prepareNextDay": planningDaily.prepareNextDay?.toMap(),
      }).catchError(handlerError);

      var listTaskRef = await planningDailyUpdate.reference?.collection("listTaskDay").get();

      var listPreventRef = await planningDailyUpdate.reference?.collection("listPreventDay").get();

      if (listTaskRef != null) {
        for (QueryDocumentSnapshot task in listTaskRef.docs) {
          task.reference.delete();
        }
        planningDaily.listTaskDay?.forEach((taskDay) {
          planningDailyUpdate.reference
              ?.collection("listTaskDay")
              .add(taskDay.toMap())
              .catchError(handlerError);
        });
      }

      if (listPreventRef != null) {
        for (QueryDocumentSnapshot prevent in listPreventRef.docs) {
          prevent.reference.delete();
        }
        planningDaily.listPreventDay?.forEach((preventDay) {
          planningDailyUpdate.reference
              ?.collection("listPreventDay")
              .add(preventDay.toMap())
              .catchError(handlerError);
        });
      }

      planningDaily.reference = planningDailyUpdate.reference;
    }

    return planningDaily;
  }

  @override
  Future<TaskOnDay> updateTask(TaskOnDay task) async {
    await task.reference?.update(task.toMap()).catchError(handlerError);
    return task;
  }

  @override
  Future<List<PlanningDaily>> findDailyPlaningForDate(
      String userUid, Timestamp dateStart, Timestamp dateEnd) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);

    QuerySnapshot querySnapshot = await refUsers
        .collection("dailyPlanning")
        .where("date", isGreaterThanOrEqualTo: dateStart)
        .where("date", isLessThanOrEqualTo: dateEnd)
        .get()
        .catchError(handlerError);

    var ListPlaningDaily = PlanningDaily.fromListDocumentSnapshot(querySnapshot.docs);

    for (PlanningDaily planning in ListPlaningDaily) {
      QuerySnapshot queryDailyGratitude =
          await planning.reference!.collection("listDailyGratitude").get().catchError(handlerError);
      QuerySnapshot queryPrevent =
          await planning.reference!.collection("listPreventDay").get().catchError(handlerError);
      QuerySnapshot queryTask =
          await planning.reference!.collection("listTaskDay").get().catchError(handlerError);
      planning.listGraditude = DailyGratitude.fromListDocumentSnapshot(queryDailyGratitude.docs);
      planning.listPreventDay = PreventOnDay.fromListDocumentSnapshot(queryPrevent.docs);
      planning.listTaskDay = TaskOnDay.fromListDocumentSnapshot(queryTask.docs);
    }

    return ListPlaningDaily;
  }

  @override
  Future<TestFreeFeature> saveTestFreeFeature(String userUid, TestFreeFeature testFreeFeature) async {

    DocumentReference refUsers = getRefCurrentUser(userUid);

    DocumentReference reference = await refUsers
        .collection("testFreeFeature")
        .add(testFreeFeature.toMap())
        .catchError(handlerError);

    testFreeFeature.reference = reference;

    return testFreeFeature;
  }

  @override
  Future<List<TestFreeFeature>> findTestFreeFeature(String userUid, TestFreeFeature testFreeFeature) async {

    DocumentReference refUsers = getRefCurrentUser(userUid);

    QuerySnapshot querySnapshot = await refUsers
        .collection("testFreeFeature")
        .where("idFeature" , isEqualTo: testFreeFeature.idFeature!)
        .get()
        .catchError(handlerError);

    return TestFreeFeature.fromListDocumentSnapshot(querySnapshot.docs);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/contract/ireport_dream_datasource.dart';

class ReportDreamDataSource extends BaseDataSource implements IReportDreamDataSource {

  @override
  Future<List<StatusDreamPeriod>> findAllStatusDreamMonth(String userUid) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    QuerySnapshot querySnapshot = await refUsers
        .collection("statusRewardOrInflection")
        .doc("MONTHS")
        .collection("statusPeriod")
        .where("periodStatusDream", isEqualTo: "MONTHLY")
        .orderBy("number", descending: true)
        .get()
        .catchError(handlerError);

    return StatusDreamPeriod.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<List<StatusDreamPeriod>> findAllStatusDreamWeek(String userUid) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    QuerySnapshot querySnapshot = await refUsers
        .collection("statusRewardOrInflection")
        .doc("WEEKS")
        .collection("statusPeriod")
        .where("periodStatusDream", isEqualTo: "WEEKLY")
        .orderBy("number", descending: true)
        .get()
        .catchError(handlerError);

    return StatusDreamPeriod.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<List<StatusDreamPeriod>> findStatusDreamWithWeek(String userUid, int numberWeek, int year) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    QuerySnapshot querySnapshot = await refUsers
        .collection("statusRewardOrInflection")
        .doc("WEEKS")
        .collection("statusPeriod")
        .where("number", isEqualTo: numberWeek)
        .where("periodStatusDream", isEqualTo: "WEEKLY")
        .where("year", isEqualTo: year)
        .get()
        .catchError(handlerError);

    return StatusDreamPeriod.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<void> saveStatusDreamWithWeek(String userUid, StatusDreamPeriod statusPeriod) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    refUsers.collection("statusRewardOrInflection")
        .doc("WEEKS")
        .collection("statusPeriod")
        .add(statusPeriod.toMap())
        .catchError(handlerError);
  }

  @override
  Future<void> saveStatusDreamWithMonth(String userUid, StatusDreamPeriod statusPeriod) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    refUsers.collection("statusRewardOrInflection")
        .doc("MONTHS")
        .collection("statusPeriod")
        .add(statusPeriod.toMap())
        .catchError(handlerError);
  }

  @override
  Future<List<StatusDreamPeriod>> findStatusDreamWithMonth(String userUid, int numberMonth, int year) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    QuerySnapshot querySnapshot = await refUsers
        .collection("statusRewardOrInflection")
        .doc("MONTHS")
        .collection("statusPeriod")
        .where("number", isEqualTo: numberMonth)
        .where("periodStatusDream", isEqualTo: "MONTHLY")
        .where("year", isEqualTo: year)
        .get()
        .catchError(handlerError);

    return StatusDreamPeriod.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<void> updateStatusDreamPeriod(StatusDreamPeriod status) async {
    return status.reference?.update(status.toMap()).catchError(handlerError);
  }

}
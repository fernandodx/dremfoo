import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';

abstract class IReportDreamDataSource {

  Future<List<StatusDreamPeriod>> findStatusDreamWithWeek(String userUid, int numberWeek, int year);

  Future<List<StatusDreamPeriod>> findStatusDreamWithMonth(String userUid, int numberMonth, int year);

  Future<void> saveStatusDreamWithWeek(String userUid, StatusDreamPeriod statusPeriod);

  Future<void> saveStatusDreamWithMonth(String userUid, StatusDreamPeriod statusPeriod);

  Future<List<StatusDreamPeriod>> findAllStatusDreamWeek(String userUid);

  Future<List<StatusDreamPeriod>> findAllStatusDreamMonth(String userUid);

  Future<void> updateStatusDreamPeriod(StatusDreamPeriod status);

}
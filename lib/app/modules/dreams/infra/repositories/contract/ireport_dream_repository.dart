import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';

abstract class IReportDreamRepository {

  Future<List<StatusDreamPeriod>> findStatusDreamWithWeek(int numberWeek, int year);

  Future<List<StatusDreamPeriod>> findStatusDreamWithMonth(int numberMonth, int year);

  Future<void> saveStatusDreamWithWeek(StatusDreamPeriod period);

  Future<void> saveStatusDreamWithMonth(StatusDreamPeriod period);

  Future<List<StatusDreamPeriod>> findAllStatusDreamWeek();

  Future<List<StatusDreamPeriod>> findAllStatusDreamMonth();

  Future<void> updateStatusDreamPeriod(StatusDreamPeriod status);

}
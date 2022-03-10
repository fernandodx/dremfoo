import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';

abstract class IReportDreamCase {

  Future<ResponseApi<List<StatusDreamPeriod>>> findStatusDreamWithWeek(int numberWeek, int year);

  Future<ResponseApi<List<StatusDreamPeriod>>> findStatusDreamWithMonth(int numberMonth, int year);

  Future<ResponseApi<void>> saveStatusDreamWithWeek(StatusDreamPeriod period);

  Future<ResponseApi<void>> saveStatusDreamWithMonth(StatusDreamPeriod period);

  Future<ResponseApi<List<StatusDreamPeriod>>> findAllStatusDreamWeek();

  Future<ResponseApi<List<StatusDreamPeriod>>> findAllStatusDreamMonth();

}
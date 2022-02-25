import 'package:dremfoo/app/modules/dreams/domain/entities/status_dream_week.dart';

class PeriodReportDto {

  int numPeriod;
  int year;
  PeriodStatusDream periodStatus;

  PeriodReportDto({required this.numPeriod, required this.periodStatus, required this.year});
}
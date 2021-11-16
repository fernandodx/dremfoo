import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';

class DreamPageDto {
  bool isDreamWait;
  Dream? dream;
  DreamPageDto({
    required this.isDreamWait,
    required this.dream});
}
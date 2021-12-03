import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';

class DreamPageDto {
  bool isDreamWait;
  bool isRemoveDream = false;
  Dream? dream;

  DreamPageDto({
    this.isDreamWait = false,
    this.isRemoveDream = false,
    required this.dream});
}
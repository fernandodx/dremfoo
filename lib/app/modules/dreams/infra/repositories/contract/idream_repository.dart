import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';

abstract class IDreamRepository {

  Future<List<Dream>> findAllDreamForUser();


}
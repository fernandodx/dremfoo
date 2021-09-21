
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';

abstract class IDreamDatasource {

  Future<List<Dream>> findAllDreamForUser(String fireBaseUserUid);

}
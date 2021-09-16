import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';

class DreamUseCase extends IDreamCase {




  @override
  Future<ResponseApi<List<Dream>>> findDreamsForUser() {
    throw UnimplementedError();
  }



}
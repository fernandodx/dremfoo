import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/home/infra/datasources/contract/ihome_datasource.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';

import 'contract/ihome_repository.dart';

class HomeRepository implements IHomeRepository {

  IHomeDatasource _datasource;
  HomeRepository(this._datasource);

  @override
  Future<List<Video>> findAllVideos(bool descending) async  {
    try{
      return _datasource.findAllVideos(descending);
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }



}
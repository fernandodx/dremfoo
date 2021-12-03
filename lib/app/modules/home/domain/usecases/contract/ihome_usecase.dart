import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';

abstract class IHomeUsecase {

  Future<ResponseApi<UserRevo>> findCurrentUser();

  Future<ResponseApi<DateTime>> findLastDayAcessForUser();

  Future<ResponseApi<List<UserRevo>>> findRankUser();

  Future<ResponseApi<List<Video>>> findAllVideos(bool descending);

  Future<ResponseApi<Video>> getRadomVideo();


}
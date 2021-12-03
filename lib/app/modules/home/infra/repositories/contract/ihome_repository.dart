import 'package:dremfoo/app/model/video.dart';

abstract class IHomeRepository {

  Future<List<Video>> findAllVideos(bool descending);
  
}
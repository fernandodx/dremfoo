import 'package:dremfoo/app/model/video.dart';

abstract class IHomeDatasource {

  Future<List<Video>> findAllVideos(bool descending);


}
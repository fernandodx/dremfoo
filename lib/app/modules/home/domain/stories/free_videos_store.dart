import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/contract/ihome_usecase.dart';
import 'package:mobx/mobx.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

part 'free_videos_store.g.dart';

class FreeVideosStore = _FreeVideosStoreBase with _$FreeVideosStore;
abstract class _FreeVideosStoreBase with Store {

  IHomeUsecase _homeUsecase;
  _FreeVideosStoreBase(this._homeUsecase);

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<Video> listVideo = ObservableList<Video>();

  List<YoutubePlayerController> controllers = [];

  Future<void> featch() async {
    _findAllVideos();
  }

  @action
  Future<void> _findAllVideos() async {
    isLoading = true;
    ResponseApi<List<Video>> responseApi = await _homeUsecase.findAllVideos(true);
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok) {
      for(Video video in responseApi.result!) {
        var youTubeController = YoutubePlayerController(
          initialVideoId: video.id!,
          flags: YoutubePlayerFlags(
            autoPlay: false,
          ),
        );
        controllers.add(youTubeController);
      }

      listVideo = responseApi.result!;
    }
    isLoading = false;
  }



}
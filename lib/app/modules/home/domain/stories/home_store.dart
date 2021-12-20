import 'package:dremfoo/app/model/level_revo.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/home/domain/stories/bottom_navigate_store.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/contract/ihome_usecase.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/iregister_user_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;
abstract class _HomeStoreBase with Store {

  IHomeUsecase _homeUsecase;
  IRegisterUserCase _registerUserCase;
  ILoginCase _loginCase;
  _HomeStoreBase(this._homeUsecase, this._registerUserCase, this._loginCase);

  @observable
  MessageAlert? msgAlert;

  @observable
  UserRevo? currentUser;

  @observable
  DateTime? lastDateAcess;

  @observable
  Video? video;

  @observable
  List<UserRevo> listRankUser = ObservableList<UserRevo>();


  Future<void> fetch() async {
    await _findCurrentUser();
    await _registerUserCase.checkLevelFocusUser();
    await _registerUserCase.updateCountAcess();
    await  _loginCase.saveLastAcessUser();
    _findLastDayAcess();
    _loadRankUser();
    _loadVideo();
  }

  @action
  Future<void> _findCurrentUser() async {
    ResponseApi<UserRevo> responseApi = await _homeUsecase.findCurrentUser();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      UserRevo _user = responseApi.result!;
      this.currentUser = _user;
    }
  }

  @action
  Future<void> _findLastDayAcess() async {
    ResponseApi<DateTime> responseApi = await _homeUsecase.findLastDayAcessForUser();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      DateTime _date = responseApi.result!;
      this.lastDateAcess = _date;
    }
  }

  @action
  Future<void> _loadRankUser() async {
    ResponseApi<List<UserRevo>> responseApi = await _homeUsecase.findRankUser();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
    List<UserRevo> _listRank = responseApi.result!;
      this.listRankUser = ObservableList.of(_listRank);
    }
  }

  @action
  Future<void> _loadVideo() async {
    ResponseApi<Video> responseApi = await _homeUsecase.getRadomVideo();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      this.video = responseApi.result;
    }
  }

  String get postionRankFormat {
    int index = listRankUser.indexWhere((rankUser) => rankUser.email == currentUser?.email);
    if(index >= 0){
      return "Posição: ${index+1}˚";
    }
    return "Sem posição";
  }

  void navigateArchivePage(BuildContext context) {
    Navigator.pushNamed(context, "/dream/archive");
  }

  void navigateDreamsCompletedPage(BuildContext context) {
    Navigator.pushNamed(context, "/dream/dreamsCompleted");
  }

  void navigateSocialNetworkPage(BuildContext context) {
    Navigator.pushNamed(context, "/socialNetwork");
  }

  void navigatePageFreeVideos(BuildContext context) {
    Navigator.pushNamed(context, "/freeVideos");
  }




}
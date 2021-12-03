import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/contract/ihome_usecase.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:mobx/mobx.dart';

part 'rank_store.g.dart';

class RankStore = _RankStoreBase with _$RankStore;
abstract class _RankStoreBase with Store {

  IHomeUsecase _homeUsecase;
  _RankStoreBase(this._homeUsecase);

  @observable
  MessageAlert? msgAlert;

  @observable
  bool isLoading = false;

  @observable
  List<UserRevo> listUserRevoRank = ObservableList.of([]);


  void fetch() {
    _loadRankUser();
  }

  @action
  Future<void> _loadRankUser() async {
    isLoading = true;
    ResponseApi<List<UserRevo>> responseApi = await _homeUsecase.findRankUser();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      List<UserRevo> _listRank = responseApi.result!;
      this.listUserRevoRank = ObservableList.of(_listRank);
    }
    isLoading = false;
  }
}
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:mobx/mobx.dart';

part 'dreams_store.g.dart';

class DreamsStore = _DreamsStoreBase with _$DreamsStore;
abstract class _DreamsStoreBase with Store {

  IDreamCase _dreamCase;
  _DreamsStoreBase(this._dreamCase);

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<Dream> listDream = ObservableList<Dream>();

  void fetchListDream() async {
    isLoading = true;
    ResponseApi<List<Dream>> responseApi = await _dreamCase.findDreamsForUser();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      listDream = responseApi.result!;
    }
    isLoading = false;
  }






}
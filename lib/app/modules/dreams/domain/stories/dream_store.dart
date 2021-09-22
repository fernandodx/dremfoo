import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:mobx/mobx.dart';

part 'dream_store.g.dart';

class DreamStore = _DreamStoreBase with _$DreamStore;
abstract class _DreamStoreBase with Store {

  IDreamCase _dreamCase;
  _DreamStoreBase(this._dreamCase);

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
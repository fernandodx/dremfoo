import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:mobx/mobx.dart';

part 'archive_store.g.dart';

class ArchiveStore = _ArchiveStoreBase with _$ArchiveStore;
abstract class _ArchiveStoreBase with Store {

  IDreamCase _dreamCase;
  _ArchiveStoreBase(this._dreamCase);

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<Dream> listDreamArchive = ObservableList.of([]);


  Future<void> fetch() async {
    _findAllDreamsArchivedCurrentUser();
  }

  @action
  Future<void> _findAllDreamsArchivedCurrentUser() async {
    isLoading = true;
    ResponseApi<List<Dream>> responseApi = await _dreamCase.findAllDreamsArchive();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok) {
      List<Dream> listDream = responseApi.result!;
      for(Dream dream in listDream) {
        ResponseApi<List<StepDream>> responseApiSteps = await _dreamCase.findStepDreamForUser(dream.uid!);
        if(responseApi.ok){
          dream.steps = responseApiSteps.result;
        }
      }
      listDreamArchive = listDream;
    }
    isLoading = false;
  }

  @action
  void restoredDream(Dream dream) {
    _dreamCase.restoreDream(dream);//validar
    listDreamArchive.remove(dream);
    listDreamArchive = ObservableList.of(listDreamArchive);
  }



}
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:mobx/mobx.dart';

part 'dream_completed_store.g.dart';

class DreamCompletedStore = _DreamCompletedStoreBase with _$DreamCompletedStore;
abstract class _DreamCompletedStoreBase with Store {

  IDreamCase _dreamCase;
  _DreamCompletedStoreBase(this._dreamCase);

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<Dream> listDreamCompleted = ObservableList.of([]);

  void fetch() {
    _findAllDreamCompleted();
  }

  @action
  Future<void> _findAllDreamCompleted() async {
    ResponseApi<List<Dream>> responseApiDream = await _dreamCase.findAllDreamsCompletedCurrentUser();
    msgAlert = responseApiDream.messageAlert;
    if(responseApiDream.ok){
      List<Dream> listDream = responseApiDream.result!;
      for(Dream dream in listDream) {
        ResponseApi<List<StepDream>> responseApiStep = await _dreamCase.findStepDreamForUser(dream.uid!);
        if(responseApiStep.ok){
          dream.steps = responseApiStep.result;
        }
      }
      listDreamCompleted = ObservableList.of(listDream);
    }
  }


}
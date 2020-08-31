import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/base_bloc.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/step_dream.dart';

class DreamsDeletedBloc extends BaseBloc {

  Future<List<Dream>> findDreamsDeleted() async {
    ResponseApi<List<Dream>> responseApi = await FirebaseService().findAllDreamsDeleted();
    if(responseApi.ok){

      List<Dream> list = responseApi.result;

      for(Dream dream in list){
        ResponseApi<List<StepDream>> responseApi = await FirebaseService().findAllStepsForDream(dream);
        dream.steps = responseApi.result;
      }
      return list;
    }

    return List();
  }

  void restoredDream(Dream dream) {
    FirebaseService().updateOnlyField("isDeleted", false, dream.reference);
  }

}
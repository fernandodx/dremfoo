import 'package:dremfoo/app/api/firebase_service.dart';
import 'package:dremfoo/app/api/bloc/base_bloc.dart';
import 'package:dremfoo/app/model/dream.dart';
import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/model/step_dream.dart';

class DreamsDeletedBloc extends BaseBloc {

  Future<List<Dream>> findDreamsDeleted() async {
    ResponseApi<List<Dream>> responseApi = await FirebaseService().findAllDreamsDeleted();
    if(responseApi.ok){

      List<Dream> list = responseApi.result!;

      for(Dream dream in list){
        ResponseApi<List<StepDream>> responseApi = await FirebaseService().findAllStepsForDream(dream);
        dream.steps = responseApi.result;
      }
      return list;
    }

    return [];
  }

  void restoredDream(Dream dream) {
    FirebaseService().updateOnlyField("isDeleted", false, dream.reference!);
  }

}
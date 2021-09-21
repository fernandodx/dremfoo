import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/contract/idream_datasource.dart';

class DreamFirebaseDatasource extends BaseDataSource implements IDreamDatasource {


  @override
  Future<List<Dream>> findAllDreamForUser(String fireBaseUserUid) async {

    DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);
    QuerySnapshot querySnapshot = await refUsers
        .collection("dreams")
        .where("isDeleted", isEqualTo: false)
        .where("dateFinish", isNull: true)
        .get()
        .catchError(handlerError);

    return Dream.fromListDocumentSnapshot(querySnapshot.docs);

  }




}
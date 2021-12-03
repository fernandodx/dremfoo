import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/base_datasource.dart';

import 'contract/ihome_datasource.dart';

class HomeDataSource extends BaseDataSource implements IHomeDatasource {


  @override
  Future<List<Video>> findAllVideos(bool descending) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("videos")
        .orderBy("date", descending: descending)
        .get();
    return Video.fromListDocumentSnapshot(querySnapshot.docs);
  }






}
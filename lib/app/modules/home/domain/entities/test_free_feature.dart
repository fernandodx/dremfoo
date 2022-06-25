import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class TestFreeFeature {

  String? idFeature;
  Timestamp? dateInit;
  int? qtdDays;
  DocumentReference? reference;

  TestFreeFeature({this.idFeature, this.dateInit, this.qtdDays, this.reference});

  TestFreeFeature.fromMap(Map<String, dynamic> map) {
    idFeature = map["idFeature"];
    dateInit = map["dateInit"];
    qtdDays = map["qtdDays"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["idFeature"] = this.idFeature;
    map["dateInit"] = dateInit;
    map["qtdDays"] = this.qtdDays;
    return map;
  }

  static List<TestFreeFeature> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      TestFreeFeature test = TestFreeFeature.fromMap(snapshot.data() as Map<String, dynamic>);
      test.reference = snapshot.reference;
      return test;
    }).toList();
  }



}
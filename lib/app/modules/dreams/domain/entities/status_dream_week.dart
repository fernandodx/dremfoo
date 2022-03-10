import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';

class StatusDreamPeriod {

  String? uid;
  Dream? dream;
  bool? isChecked;
  bool? isExpanded;
  String? descriptionAction;
  TypeStatusDream? typeStatusDream;
  double? difficulty;
  int? number;
  int? year;
  double? percentCompleted;
  PeriodStatusDream? periodStatusDream;
  DocumentReference? reference;

  StatusDreamPeriod({this.dream, this.isChecked, this.descriptionAction,
      this.typeStatusDream, this.difficulty, this.number, this.year, this.periodStatusDream, this.percentCompleted});

  static StatusDreamPeriod fromMap(data){
    StatusDreamPeriod status = StatusDreamPeriod();
    status.isChecked = data['isChecked'];
    status.dream = Dream.fromMap(data['dream']);
    status.descriptionAction = data['descriptionAction'];
    status.difficulty = data['difficulty'];
    status.typeStatusDream = TypeStatusDream.values.where((type) => type.isEqual(data['typeStatusDream'])).first;
    status.number = data['number'];
    status.year = data['year'];
    status.periodStatusDream = PeriodStatusDream.values.where((type) => type.isEqual(data['periodStatusDream'])).first;
    status.percentCompleted = data['percentCompleted'];

    return status;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isChecked'] = this.isChecked;
    data['descriptionAction'] = this.descriptionAction;
    data['difficulty'] = this.difficulty;
    data['typeStatusDream'] = this.typeStatusDream?.name();
    data['number'] = this.number;
    data['year'] = this.year;
    data['periodStatusDream'] = this.periodStatusDream?.name();
    data['percentCompleted'] = this.percentCompleted;
    data['dream'] = dream?.toMap();
    return data;
  }

  static List<StatusDreamPeriod> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      StatusDreamPeriod status = StatusDreamPeriod.fromMap(snapshot.data());
      status.reference = snapshot.reference;
      status.uid = snapshot.id;
      return status;
    }).toList();
  }
}

enum TypeStatusDream {
  INFLECTION, REWARD
}

enum PeriodStatusDream {
  WEEKLY, MONTHLY
}

extension FormatToStringTypeStatus on TypeStatusDream {
  String name() {
    return this.toString().split('.').last;
  }

  bool isEqual(String name) {
    return this.toString().split('.').last == name;
  }
}

extension FormatToStringPeriodStatus on PeriodStatusDream {
  String name() {
    return this.toString().split('.').last;
  }

  bool isEqual(String name) {
    return this.toString().split('.').last == name;
  }
}
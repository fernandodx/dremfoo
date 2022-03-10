import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionPurchased {

  String? productID;
  String? purchaseID;
  Timestamp? transactionDate;
  bool? isEnable;
  DocumentReference? reference;

  SubscriptionPurchased({this.productID, this.purchaseID, this.transactionDate, this.reference, this.isEnable});

  SubscriptionPurchased.fromMap(Map<String, dynamic> map) {
    productID = map["productID"];
    purchaseID = map["purchaseID"];
    transactionDate = map["transactionDate"];
    isEnable = map["isEnable"];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["productID"] = this.productID;
    map["purchaseID"] = this.purchaseID;
    map['transactionDate'] = this.transactionDate;
    map['isEnable'] = this.isEnable;
    return map;
  }

  static List<SubscriptionPurchased> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      SubscriptionPurchased purchased = SubscriptionPurchased.fromMap(snapshot.data() as Map<String, dynamic>);
      purchased.reference = snapshot.reference;
      return purchased;
    }).toList();
  }
}
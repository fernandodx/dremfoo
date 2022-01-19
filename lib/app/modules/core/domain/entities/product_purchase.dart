import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPurchase {

  String? uid;
  String? name;
  late DocumentReference reference;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    return data;
  }

  static ProductPurchase fromMap(data){
    ProductPurchase product = ProductPurchase();
    product.uid = data['uid'];
    product.name = data['name'];
    return product;
  }

  static List<ProductPurchase> fromListDocumentSnapshot(List<QueryDocumentSnapshot> list){
    return list.map((snapshot) {
      ProductPurchase product = fromMap(snapshot.data());
      product.reference = snapshot.reference;
      product.uid = snapshot.id;
      return product;
    }).toList();
  }


}
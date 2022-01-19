import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';

import 'base_datasource.dart';
import 'contract/ipurchase_datasource.dart';

class PurchaseDatasource extends BaseDataSource implements IPurchaseDatasource {


  @override
  Future<List<ProductPurchase>> findAllProductPurchase() async {

    QuerySnapshot querySnapshot = await firestore
        .collection("subscriptionType")
        .get();
    return ProductPurchase.fromListDocumentSnapshot(querySnapshot.docs);

  }




}
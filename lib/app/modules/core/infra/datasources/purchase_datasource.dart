import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/subscription_purchased.dart';

import 'base_datasource.dart';
import 'contract/ipurchase_datasource.dart';

class PurchaseDatasource extends BaseDataSource implements IPurchaseDatasource {

  @override
  Future<List<ProductPurchase>> findAllProductPurchase() async {
    QuerySnapshot querySnapshot = await firestore.collection("subscriptionType").get();
    return ProductPurchase.fromListDocumentSnapshot(querySnapshot.docs);
  }

  @override
  Future<void> saveProductPurchased(String userUid, SubscriptionPurchased purchased) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    refUsers.collection("subscriptionPurchased").add(purchased.toMap()).catchError(handlerError);
  }

  @override
  Future<List<SubscriptionPurchased>> loadProductPurchased(String userUid, SubscriptionPurchased purchased) async {
    DocumentReference refUsers = getRefCurrentUser(userUid);
    QuerySnapshot querySnapshot = await refUsers
        .collection("subscriptionPurchased")
        .where("productID", isEqualTo: purchased.productID)
        .get();
    return SubscriptionPurchased.fromListDocumentSnapshot(querySnapshot.docs);
  }
}

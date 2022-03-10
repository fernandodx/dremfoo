import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/subscription_purchased.dart';

abstract class IPurchaseDatasource {

  Future<List<ProductPurchase>> findAllProductPurchase();

  Future<void> saveProductPurchased(String userUid, SubscriptionPurchased purchased);

  Future<List<SubscriptionPurchased>> loadProductPurchased(String userUid, SubscriptionPurchased purchased);

}
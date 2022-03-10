import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/subscription_purchased.dart';

abstract class IPurchaseRepository {

  Future<List<ProductPurchase>> findAllProductPurchase();

  Future<void> saveProductPurchased(SubscriptionPurchased purchased);

  Future<List<SubscriptionPurchased>> loadProductPurchased(SubscriptionPurchased purchased);

}
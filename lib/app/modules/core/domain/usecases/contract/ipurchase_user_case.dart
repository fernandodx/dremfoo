import 'dart:ffi';

import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/subscription_purchased.dart';

abstract class IPurchaseUserCase {

  Future<ResponseApi<List<ProductPurchase>>> findAllProductPurchase();

  Future<ResponseApi<Void>> saveProductPurchased(SubscriptionPurchased purchased);

  Future<ResponseApi<List<SubscriptionPurchased>>> loadProductPurchased(SubscriptionPurchased purchased);

}
import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';

abstract class IPurchaseRepository {

  Future<List<ProductPurchase>> findAllProductPurchase();

}
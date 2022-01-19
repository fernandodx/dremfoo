import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';

abstract class IPurchaseDatasource {

  Future<List<ProductPurchase>> findAllProductPurchase();

}
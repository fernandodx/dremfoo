import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';

abstract class IPurchaseUserCase {

  Future<ResponseApi<List<ProductPurchase>>> findAllProductPurchase();

}
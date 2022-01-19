import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/contract/ipurchase_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ipurchase_repository.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';

class PurchaseRepository implements IPurchaseRepository {

  IPurchaseDatasource _iPurchaseDatasource;
  PurchaseRepository(this._iPurchaseDatasource);

  @override
  Future<List<ProductPurchase>> findAllProductPurchase() async {
    try{
      return await _iPurchaseDatasource.findAllProductPurchase();
    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

}
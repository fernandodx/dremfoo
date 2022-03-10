import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/subscription_purchased.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/contract/ipurchase_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ipurchase_repository.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

  @override
  Future<List<SubscriptionPurchased>> loadProductPurchased(SubscriptionPurchased purchased) {
    try{

      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return _iPurchaseDatasource.loadProductPurchased(_userRevo.uid!, purchased);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

  @override
  Future<void> saveProductPurchased(SubscriptionPurchased purchased) {
    try{

      var _userRevo = Modular.get<UserRevo>();

      if(_userRevo.uid != null){
        return _iPurchaseDatasource.saveProductPurchased(_userRevo.uid!, purchased);
      }else{
        RevoExceptions _revoExceptions = new RevoExceptions
            .msgToUser(error: Exception("userRevo.uid == null"), msg: "Login não encontrado!");
        CrashlyticsUtil.logError(_revoExceptions);
        throw _revoExceptions;
      }

    } catch(error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      throw new RevoExceptions.msgToUser(stack: stack, error: Exception(error), msg: "Ops! Aconteceu um erro inesperado.");
    }
  }

}
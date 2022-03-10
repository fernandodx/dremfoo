import 'dart:ffi';

import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/subscription_purchased.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/usecases/contract/ipurchase_user_case.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ipurchase_repository.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';

class PurchaseUserCase implements IPurchaseUserCase {

  IPurchaseRepository _purchaseRepository;
  PurchaseUserCase(this._purchaseRepository);

  @override
  Future<ResponseApi<List<ProductPurchase>>> findAllProductPurchase() async {
    try{

      List<ProductPurchase> listProduct =  await _purchaseRepository.findAllProductPurchase();
      return ResponseApi.ok(result: listProduct);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);

  }

  @override
  Future<ResponseApi<List<SubscriptionPurchased>>> loadProductPurchased(SubscriptionPurchased purchased) async {
    try{

      List<SubscriptionPurchased> listProduct =  await _purchaseRepository.loadProductPurchased(purchased);
      return ResponseApi.ok(result: listProduct);

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

  @override
  Future<ResponseApi<Void>> saveProductPurchased(SubscriptionPurchased purchased) async {
    try{

      await _purchaseRepository.saveProductPurchased(purchased);
      return ResponseApi.ok();

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }




}
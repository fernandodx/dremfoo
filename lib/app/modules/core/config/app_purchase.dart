import 'dart:async';

import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/usecases/contract/ipurchase_user_case.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';

part 'app_purchase.g.dart';

class AppPurchase = _AppPurchaseBase with _$AppPurchase;

abstract class _AppPurchaseBase with Store {

  IPurchaseUserCase _purchaseUserCase;
  _AppPurchaseBase(this._purchaseUserCase);

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @observable
  bool isEnableSubscription = false;

  @observable
  bool isError = false;

  @observable
  bool isPending = false;

  @computed
  bool get isShowAd {
    if(isEnableSubscription){
      return false;
    }else{
      return true;
    }
  }

  Future<void> initListenerPurchase() async {

    final Stream<List<PurchaseDetails>> _purchaseUpdate = InAppPurchase.instance.purchaseStream;

    _subscription = _purchaseUpdate.listen((purchaseDetailsList) {

      _listenerToPurchaseUpdade(purchaseDetailsList);

    }, onDone: () {
      isEnableSubscription = false;
      _subscription.cancel();
    }, onError: (error) {
      isEnableSubscription = false;
      isError = true;
      CrashlyticsUtil.logErro(Exception("Erro no listener Purchase : $error"), null);
    });
  }

  void _listenerToPurchaseUpdade(List<PurchaseDetails> listDetailPurchase) {

    listDetailPurchase.forEach((PurchaseDetails purchaseDetails) async {

      if(purchaseDetails.status != PurchaseStatus.pending
          && purchaseDetails.pendingCompletePurchase){
        isEnableSubscription = true;
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }

      switch(purchaseDetails.status) {

        case PurchaseStatus.pending:
          isEnableSubscription = false;
          break;

        case PurchaseStatus.error:
          isEnableSubscription = false;
          isError = true;
          CrashlyticsUtil.logErro(Exception("Erro no PurchaseStatus : ${purchaseDetails.error}"), null);
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          isEnableSubscription = true;
          isError = false;
          break;

        case PurchaseStatus.canceled:
          isEnableSubscription = false;
          break;
      }
    });
  }

  Future<ResponseApi<List<ProductDetails>>> findProductsForSale() async {

    Set<String> _products = <String>{};

    ResponseApi<List<ProductPurchase>> responsePurchase = await _purchaseUserCase.findAllProductPurchase();
    if(responsePurchase.ok){

      List<ProductPurchase> listPurchaseProducts = responsePurchase.result!;

      listPurchaseProducts.forEach((purchase) {
        _products.add(purchase.uid!);
      });

      ProductDetailsResponse _response = await InAppPurchase.instance.queryProductDetails(_products);
      if(_response.notFoundIDs.isNotEmpty){
        RevoExceptions exceptions = RevoExceptions.msgToUser(msg: _response.error.toString(),);
        CrashlyticsUtil.logErro(exceptions, exceptions.stack);
        return ResponseApi.error(messageAlert: MessageAlert.create("Erro na Assinatura", "Não foram encontrados planos para assinatura", TypeAlert.ERROR));
      }

      List<ProductDetails> products = _response.productDetails;
      return ResponseApi.ok(result: products);
    }

    return ResponseApi.error(messageAlert: MessageAlert.create("Erro na Assinatura", "Não foram encontrados produtos para a assinatura.", TypeAlert.ERROR));
  }

  Future<void> restorePurchase() async {
    await InAppPurchase.instance.restorePurchases();
  }

  Future<bool> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    // if(product.title == "no_advertisements"){
    //   InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    // }

    if(product.id.toLowerCase().contains("assinatura")){
      return InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    }

    return false;
  }

  Future<bool> _verifyPurchaseAvailable() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
      return false;
    }
    return true;
  }




}
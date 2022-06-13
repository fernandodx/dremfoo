import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/product_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/subscription_purchased.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/usecases/contract/ipurchase_user_case.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';


part 'app_purchase.g.dart';

class AppPurchase = _AppPurchaseBase with _$AppPurchase;

abstract class _AppPurchaseBase with Store {

  IPurchaseUserCase _purchaseUserCase;

  _AppPurchaseBase(this._purchaseUserCase);

  late StreamSubscription<List<PurchaseDetails>> subscription;

  @observable
  bool isEnableSubscription = false;

  @observable
  bool isError = false;

  @observable
  bool isPending = false;

  @computed
  bool get isShowAd {
    if (isEnableSubscription) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> initPurchased() async {
    var isAvailable = await verifyPurchaseAvailable();

    if (!isAvailable) {
      isError = true;
      setEnableSubscription(false);
      return;
    }

    ResponseApi<List<ProductPurchase>> responsePurchase = await _purchaseUserCase.findAllProductPurchase();

    if (responsePurchase.ok) {
      List<String> listUidProduct = responsePurchase.result!
          .map((product) => product.uid!)
          .toList();

      ProductDetailsResponse detailsResponse = await InAppPurchase.instance.queryProductDetails(
          listUidProduct.toSet());

      if (detailsResponse.error != null) {
        CrashlyticsUtil.logErro(Exception(detailsResponse.error?.message ?? "Erro no queryProductDetails"), null);
        isError = true;
        setEnableSubscription(false);
        return;
      }

      if (detailsResponse.productDetails.isEmpty) {
        isError = true;
        setEnableSubscription(false);
        return;
      }

      var purchased = detailsResponse.productDetails.first;
      var subscription = SubscriptionPurchased(isEnable: true, productID: purchased.id);

      var responsePurchased = await _purchaseUserCase.loadProductPurchased(subscription);
      if (responsePurchased.ok) {
        var listSubscriptionPurchased = responsePurchased.result!;
        if (listSubscriptionPurchased.isNotEmpty && listSubscriptionPurchased.first.isEnable == true) {
          setEnableSubscription(true);
        } else {
          setEnableSubscription(false);
        }
      }
    }
  }

  @action
  void setEnableSubscription(bool isEnable){
    this.isEnableSubscription = isEnable;
  }

  Future<StreamSubscription> initListenerPurchase() async {

    final Stream<List<PurchaseDetails>> _purchaseUpdate = InAppPurchase.instance.purchaseStream;

      subscription = await _purchaseUpdate.listen((purchaseDetailsList) {
        _listenerToPurchaseUpdade(purchaseDetailsList);
      }, onDone: () {
        isEnableSubscription = false;
        subscription.cancel();
      }, onError: (error) {
        isEnableSubscription = false;
        isError = true;
        CrashlyticsUtil.logErro(Exception("Erro no listener Purchase : $error"), null);
      });

      return subscription;
    }

    void _listenerToPurchaseUpdade(List<PurchaseDetails> listDetailPurchase) {
      listDetailPurchase.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status != PurchaseStatus.pending
            && purchaseDetails.pendingCompletePurchase) {
          await deliveredSubscription(isEnable: true, purchaseDetails: purchaseDetails);
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }

        switch (purchaseDetails.status) {
          case PurchaseStatus.pending:
            isEnableSubscription = false;
            break;

          case PurchaseStatus.error:
            isEnableSubscription = false;
            isError = true;
            CrashlyticsUtil.logErro(
                Exception("Erro no PurchaseStatus : ${purchaseDetails.error}"), null);
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            await deliveredSubscription(isEnable: true, purchaseDetails: purchaseDetails);
            break;

          case PurchaseStatus.canceled:
            isEnableSubscription = false;
            break;
        }
      });
    }

    Future<ResponseApi<List<ProductDetails>>> findProductsForSale() async {
      Set<String> _products = <String>{};

      ResponseApi<List<ProductPurchase>> responsePurchase = await _purchaseUserCase
          .findAllProductPurchase();
      if (responsePurchase.ok) {
        List<ProductPurchase> listPurchaseProducts = responsePurchase.result!;

        if (listPurchaseProducts.isEmpty) {
          RevoExceptions exceptions = RevoExceptions.msgToUser(msg: "listPurchaseProducts vazia",);
          CrashlyticsUtil.logErro(exceptions, exceptions.stack);
          return ResponseApi.error(messageAlert: MessageAlert.create(
              Translate.i().get.label_error_subscription,  Translate.i().get.label_no_found_subscription, TypeAlert.ERROR));
        }

        for (ProductPurchase product in listPurchaseProducts) {
          _products.add(product.uid!);
        }

        ProductDetailsResponse _response = await InAppPurchase.instance.queryProductDetails(
            _products);
        if (_response.notFoundIDs.isNotEmpty) {
          RevoExceptions exceptions = RevoExceptions.msgToUser(msg: _response.error.toString(),);
          CrashlyticsUtil.logErro(exceptions, exceptions.stack);
          return ResponseApi.error(messageAlert: MessageAlert.create(
              Translate.i().get.label_error_subscription, Translate.i().get.label_no_found_plans,
              TypeAlert.ERROR));
        }

        List<ProductDetails> products = _response.productDetails;
        return ResponseApi.ok(result: products);
      }

      return ResponseApi.error(messageAlert: responsePurchase.messageAlert,);
    }

    Future<void> restorePurchase() async {
      InAppPurchase.instance.restorePurchases();
    }

    Future<bool> buyProduct(ProductDetails product) async {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

      // if(product.title == "no_advertisements"){
      //   InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
      // }

      if (product.id.toLowerCase().contains("assinatura")) {
        return InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
      }

      return false;
    }

    Future<bool> verifyPurchaseAvailable() async {
      final bool available = await InAppPurchase.instance.isAvailable();
      return available;
    }

    @action
    Future<void> deliveredSubscription(
        {required PurchaseDetails purchaseDetails, required bool isEnable}) async {
      var response = await saveSubscriptionPurchased(
          purchaseDetails: purchaseDetails, isEnable: isEnable);
      if (response.ok) {
        isEnableSubscription = true;
        isError = false;
      } else {
        isEnableSubscription = false;
        isError = true;
      }
    }

    Future<ResponseApi<Void>> saveSubscriptionPurchased(
        {required PurchaseDetails purchaseDetails, required bool isEnable}) async {

      late DateTime date;
      if(purchaseDetails.transactionDate != null){
        date = DateTime.fromMicrosecondsSinceEpoch(int.parse(purchaseDetails.transactionDate!));
      }else{
        date = DateTime.now();
      }

      var subscription = SubscriptionPurchased(
          productID: purchaseDetails.productID,
          purchaseID: purchaseDetails.purchaseID,
          transactionDate: Timestamp.fromDate(date),
          isEnable: isEnable
      );
      return await _purchaseUserCase.saveProductPurchased(subscription);
    }


  }


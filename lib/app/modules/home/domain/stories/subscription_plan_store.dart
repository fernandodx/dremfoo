import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';

import '../../../../utils/analytics_util.dart';

part 'subscription_plan_store.g.dart';

class SubscriptionPlanStore = _SubscriptionPlanStoreBase with _$SubscriptionPlanStore;

abstract class _SubscriptionPlanStoreBase with Store {

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<ProductDetails> listProductForSale = ObservableList.of([]);

  @action
  Future<void> featch() async {

    AnalyticsUtil.sendAnalyticsEvent(EventRevo.showPageSubscription);

    AppPurchase _appPurchase = Modular.get<AppPurchase>();

    bool isAvaiable =  await _appPurchase.verifyPurchaseAvailable();
    if(!isAvaiable) {
      msgAlert = MessageAlert.create("Erro na loja", "Ops! A Store esta indisponível no momento.", TypeAlert.ALERT);
    }

    isLoading = true;
    ResponseApi<List<ProductDetails>> responseApiProduct = await _appPurchase.findProductsForSale();
    msgAlert = responseApiProduct.messageAlert;
    if(responseApiProduct.ok){
      listProductForSale = ObservableList.of(responseApiProduct.result!);
      if(listProductForSale.isEmpty){
        msgAlert = MessageAlert.create("Ops!", "Não há nenhuma assinatura disponivel no momento", TypeAlert.ALERT);
      }
    }

    isLoading = false;

  }

  Future<bool> buyProductSelected(ProductDetails product) async {
    AppPurchase _appPurchase = Modular.get<AppPurchase>();
    return _appPurchase.buyProduct(product);
  }

  Future<void> restorePurchase() async {
    AppPurchase _appPurchase = Modular.get<AppPurchase>();
    return _appPurchase.restorePurchase();
  }

}
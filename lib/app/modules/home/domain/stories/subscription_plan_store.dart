import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';

part 'subscription_plan_store.g.dart';

class SubscriptionPlanStore = _SubscriptionPlanStoreBase with _$SubscriptionPlanStore;

abstract class _SubscriptionPlanStoreBase with Store {

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  List<ProductDetails> listProductForSale = ObservableList.of([]);

  Future<void> featch() async {

    AppPurchase _appPurchase = Modular.get<AppPurchase>();

    if(!_appPurchase.isEnableSubscription){
      isLoading = true;

      ResponseApi<List<ProductDetails>> responseApiProduct = await _appPurchase.findProductsForSale();
      msgAlert = responseApiProduct.messageAlert;
      if(responseApiProduct.ok){
        listProductForSale = ObservableList.of(responseApiProduct.result!);
      }

      isLoading = false;
    }

  }

  Future<bool> buyProductSelected(ProductDetails product) async {
    AppPurchase _appPurchase = Modular.get<AppPurchase>();
    return _appPurchase.buyProduct(product);
  }

}
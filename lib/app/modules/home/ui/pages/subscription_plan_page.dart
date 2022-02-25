import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/alert_bottom_sheet.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/button_outlined_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/loading_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/subscription_plan_store.dart';
import 'package:dremfoo/app/modules/home/ui/widgets/chip_button_widget.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPlanPage extends StatefulWidget {
  const SubscriptionPlanPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPlanPageState createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends ModularState<SubscriptionPlanPage, SubscriptionPlanStore> {

  late AppPurchase _appPurchase;

  @override
  void initState() {
    super.initState();

    _appPurchase = Modular.get<AppPurchase>();

    var overlayLoading = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black38,
        alignment: Alignment.center,
        child: LoadingWidget(Translate.i().get.label_loading_plans),
      );
    });

    reaction<bool>((_) => store.isLoading, (isLoading) {
      if (isLoading) {
        Overlay.of(context)!.insert(overlayLoading);
      } else {
        overlayLoading.remove();
      }
    });

    reaction<MessageAlert?>((_) => store.msgAlert, (msgErro) {
      if (msgErro != null) {
        alertBottomSheet(context, msg: msgErro.msg, title: msgErro.title, type: msgErro.type);
      }
    });

    reaction<bool>((_) => _appPurchase.isError, (isErro) {
      if (isErro) {
        alertBottomSheet(context,
            msg: Translate.i().get.msg_erro_purchase,
            title: Translate.i().get.title_erro_purchase,
            type: TypeAlert.ERROR);
      }
    });

    reaction<bool>((_) => _appPurchase.isPending, (isPending) {
      if (isPending) {
        alertBottomSheet(context,
            msg: Translate.i().get.msg_erro_pending_purchase,
            title: Translate.i().get.label_erro_pending_purchase,
            type: TypeAlert.ERROR);
      }
    });

    store.featch();
  }

  @override
  void dispose() {
    _appPurchase.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar(Translate.i().get.label_premium_access),
      ),
      bottomSheet: Observer(builder: (context) => purchasePlanOrThanks(store.listProductForSale)),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          Utils.getPathAssetsImg(
                            "logo_compra_app.png",
                          ),
                          fit: BoxFit.cover,
                          width: 110,
                          height: 110,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            Utils.getPathAssetsImg(
                              "logo_compra_pagamento.png",
                            ),
                            fit: BoxFit.cover,
                            width: 110,
                            height: 110,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            Expanded(
                flex: 6,
                child: ListView(
                  children: [
                    Text(
                      Translate.i().get.label_description_subscription,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () => launch("https://www.instagram.com/movimentodesperte"),
                      leading: FaIcon(FontAwesomeIcons.instagram),
                      title: TextUtil.textTitulo(Translate.i().get.title_subscription_donated),
                      subtitle: TextUtil.textSubTitle(Translate.i().get.msg_purchase_2022, align: TextAlign.justify),
                      trailing: Icon(Icons.chevron_right),
                      textColor: Theme.of(context).textTheme.subtitle1?.color,

                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ListTile(
                      leading: Container(
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                Utils.getPathAssetsImg(
                                  "logo_app_sem_propaganda.png",
                                ),
                                fit: BoxFit.cover,
                                width: 45,
                                height: 45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: TextUtil.textTitulo(Translate.i().get.label_no_ad),
                      subtitle:
                          TextUtil.textSubTitle(Translate.i().get.label_no_ad_description),
                        textColor: Theme.of(context).textTheme.subtitle1?.color,
                    ),
                    ListTile(
                      leading: Container(
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                Utils.getPathAssetsImg(
                                  "logo_novas_funcionalidade.png",
                                ),
                                fit: BoxFit.cover,
                                width: 45,
                                height: 45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: TextUtil.textTitulo(Translate.i().get.label_access_new_features),
                      subtitle: TextUtil.textSubTitle(
                        Translate.i().get.label_no_miss_features,
                      ),
                        textColor: Theme.of(context).textTheme.subtitle1?.color,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget purchasePlanOrThanks(List<ProductDetails>? listProductPurchase) {
    if(_appPurchase.isEnableSubscription){
      return containerThanksPurchase();
    }else{
      return buttonsPurchaseRevo(listProductPurchase);
    }
  }

  Widget containerThanksPurchase(){
   return Container(
     color: Theme.of(context).scaffoldBackgroundColor,
     child: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: Theme.of(context).canvasColor),
        ),
        child: ListTile(
          leading: FaIcon(FontAwesomeIcons.check, color: Theme.of(context).canvasColor, size: 40,),
          title: TextUtil.textTitulo("Assinatura Ativa"),
          subtitle: TextUtil.textDefault("Muito obrigado! Você nos ajuda a manter o app e fazer doações de cestas básicas.",),
          textColor: Theme.of(context).textTheme.subtitle1?.color,
        ),
      ),
   );
  }

  Widget buttonsPurchaseRevo(List<ProductDetails>? listProductPurchase) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 16),
      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: creatButtonsPlanPurchase(
                listProduct: listProductPurchase,
                productSelected: (product) {
                  store.buyProductSelected(product);
                }
            ),
          ),
    );
  }

  List<Widget> creatButtonsPlanPurchase({
    required List<ProductDetails>? listProduct,
    required Function(ProductDetails) productSelected}) {
    List<Widget> list = [];

    if(listProduct != null) {

      for(ProductDetails product in listProduct) {
        var labelButtom = "";
        if (product.id.toLowerCase().contains("mensal")) {
          labelButtom = "Assinatura Mensal • ${product.price} por mês";
        } else if (product.id.toLowerCase().contains("anual")) {
          labelButtom = "Assinatura Anual • ${product.price} por ano";
        }

        list.add(Container(
          margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: ChipButtonWidget(
              name: labelButtom,
              size: 250,
              fontSize: 14,
              icon: FontAwesomeIcons.creditCard,
              onTap: () {
                productSelected.call(product);
              }),
        ));
      }

    }else{
      list.add(Container(child: Center(),));
    }
    return list;
  }
}

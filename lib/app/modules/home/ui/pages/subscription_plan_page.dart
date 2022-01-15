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

class SubscriptionPlanPage extends StatefulWidget {
  const SubscriptionPlanPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPlanPageState createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends ModularState<SubscriptionPlanPage, SubscriptionPlanStore> {

  AppPurchase _appPurchase = Modular.get<AppPurchase>();

  @override
  void initState() {
    super.initState();

    var overlayLoading = OverlayEntry(builder: (context) {
      return Container(
        color: Colors.black38,
        alignment: Alignment.center,
        child: LoadingWidget("Carregando planos"),
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
            msg: "Tivemos um erro na compra da sua assinatura, verifique a google play.",
            title: "Erro na assinatura do Revo",
            type: TypeAlert.ERROR
        );
      }
    });

    reaction<bool>((_) => _appPurchase.isPending, (isPending) {
      if (isPending) {
        alertBottomSheet(context,
            msg: "O pgamento da sua assinatura esta pendente, verifique a google play.",
            title: "Pagamento pendente na assinatura do Revo",
            type: TypeAlert.ERROR
        );
      }
    });

    store.featch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar("Acesso Premium"),
      ),
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
                      "Assinatura Revo - Metas com foco",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    Divider(),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: TextUtil.textSubTitle(
                          "No Ano de 2022 toda a arrecadação com  assinaturas premium, será destinada a compras de cestas báscicas para o Movimento Desperte.",
                          //https://www.instagram.com/movimentodesperte/
                          align: TextAlign.justify,
                      ),
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
                      title: TextUtil.textTitulo("Sem propagandas"),
                      subtitle:
                          TextUtil.textSubTitle("Navegue tranquilo pelo app sem publicidade."),
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
                      title: TextUtil.textTitulo("Acesso as novas funcionalidades"),
                      subtitle: TextUtil.textDefault(
                        "Não perca a chance de acessar as melhores funções que estão por vim.",
                      ),
                        textColor: Theme.of(context).textTheme.subtitle1?.color,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Observer(builder: (context) => purchasePlanOrThanks()),

                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget purchasePlanOrThanks() {
    if(_appPurchase.isEnableSubscription){
      return containerThanksPurchase();
    }else{
      return buttonsPurchaseRevo();
    }
  }

  Widget containerThanksPurchase(){
   return Container(
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
    );
  }

  Widget buttonsPurchaseRevo() {
    return Expanded(
      flex: 3,
      child: Observer(
        builder: (context) => Column(
          children: creatButtonsPlanPurchase(
              listProduct: store.listProductForSale,
              productSelected: (product) {
                store.buyProductSelected(product);
              }
          ),
        ),
      ),
    );
  }

  List<Widget> creatButtonsPlanPurchase({
    required List<ProductDetails> listProduct,
    required Function(ProductDetails) productSelected}) {
    List<Widget> list = [];

    listProduct.forEach((product) {

      var labelButtom = "";
      if(product.id.toLowerCase().contains("mensal")){
        labelButtom = "Assinatura Mensal • ${product.price} por mês";
      } else if(product.id.toLowerCase().contains("anual")){
        labelButtom = "Assinatura Anual • ${product.price} por ano";
      }

      list.add(Container(
        margin: EdgeInsets.only(bottom: 16),
        child: ChipButtonWidget(
            name: labelButtom,
            size: 250,
            fontSize: 14,
            icon: FontAwesomeIcons.creditCard,
            onTap: () {
              productSelected.call(product);
            }),
      ));
    });

    return list;
  }
}

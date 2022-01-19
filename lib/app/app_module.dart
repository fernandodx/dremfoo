import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/usecases/purchase_user_case.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/purchase_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/puchase_repository.dart';
import 'package:dremfoo/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [

    Bind.lazySingleton((i) => PurchaseDatasource(), export: true),
    Bind.lazySingleton((i) => PurchaseRepository(i.get<PurchaseDatasource>()), export: true),
    Bind.lazySingleton((i) => PurchaseUserCase(i.get<PurchaseRepository>()), export: true),
    Bind.lazySingleton((i) => AppPurchase(i.get<PurchaseUserCase>()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    // ModuleRoute(MODULE_HOME, module: HomeModule()),
    // ModuleRoute(MODULE_DREAM, module: DreamsModule()),

    // ModuleRoute(Modular.initialRoute, module: HomeModule()),
    // ModuleRoute(MODULE_DREAM, module: DreamsModule()),
  ];


  static final String MODULE_HOME = "/home";
  static final String MODULE_DREAM = "/dream";
}

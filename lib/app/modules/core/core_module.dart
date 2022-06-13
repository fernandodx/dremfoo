import 'package:dremfoo/app/app_module.dart';
import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/core/domain/usecases/SeoUserCase.dart';
import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/shared_prefs_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/upload_image_picker_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/shared_prefs_repository.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/upload_image_repository.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/usecases/purchase_user_case.dart';
import 'infra/datasources/purchase_datasource.dart';
import 'infra/repositories/puchase_repository.dart';

class CoreModule extends Module {

  @override
  final List<Bind> binds = [

    Bind.lazySingleton((i) => PurchaseDatasource(), export: true,),
    Bind.lazySingleton((i) => PurchaseRepository(i.get<PurchaseDatasource>()), export: true),
    Bind.lazySingleton((i) => PurchaseUserCase(i.get<PurchaseRepository>()), export: true),
    Bind.singleton((i) => AppPurchase(i.get<PurchaseUserCase>()), export: true),


    Bind.instance<String>("KEY", export: true),
    Bind.lazySingleton((i) => RevoAnalytics(), export: true),
    Bind.singleton((i) => UserRevo(), export: true,),
    Bind.lazySingleton((i) => Dream(), export: true),

    Bind.lazySingleton((i) => UploadImagePickerDataSource(), export: true),
    Bind.lazySingleton((i) => SharedPrefdDatasource(), export: true),

    Bind.lazySingleton((i) => UploadImageRepository(i.get<UploadImagePickerDataSource>()), export: true),
    Bind.lazySingleton((i) => SharedPrefsRepository(i.get<SharedPrefdDatasource>()), export: true),

    Bind.lazySingleton((i) => SeoUserCase(i.get<SharedPrefsRepository>()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [];
}

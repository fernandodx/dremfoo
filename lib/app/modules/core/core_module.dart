import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/core/infra/datasources/upload_image_picker_datasource.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/upload_image_repository.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [

    Bind.instance<String>("KEY", export: true),
    Bind.lazySingleton((i) => RevoAnalytics(), export: true),
    Bind.lazySingleton((i) => UserRevo(), export: true),
    Bind.lazySingleton((i) => Dream(), export: true),

    Bind.lazySingleton((i) => UploadImagePickerDataSource(), export: true),
    Bind.lazySingleton((i) => UploadImageRepository(i.get<UploadImagePickerDataSource>()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [];
}

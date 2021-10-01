import 'package:dremfoo/app/modules/core/core_module.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dream_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/dream_usecase.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/dream_firebase_datasource.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/dream_repository.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/detail_dream_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/dreams_page.dart';
import 'package:dremfoo/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamsModule extends Module {

  @override
  final List<Module> imports = [
    CoreModule(),
  ];

  @override
  final List<Bind> binds = [

    Bind.lazySingleton((i) => DreamFirebaseDatasource()),
    Bind.lazySingleton((i) => DreamRespository(i.get<DreamFirebaseDatasource>())),
    Bind.lazySingleton((i) => DreamUseCase(i.get<DreamRespository>())),

    Bind.lazySingleton((i) => DetailDreamStore(i.get<DreamUseCase>())),
    Bind.lazySingleton((i) => DreamStore(i.get<DreamUseCase>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => DreamsPage(), transition: TransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 800)),
    ChildRoute("/detail", child: (_, args) => DetailDreamPage(args.data), transition: TransitionType.rightToLeftWithFade, duration: Duration(milliseconds: 800)),
  ];
}

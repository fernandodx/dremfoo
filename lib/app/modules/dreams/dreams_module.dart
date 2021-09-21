import 'package:dremfoo/app/modules/dreams/domain/stories/dreams_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/dream_usecase.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/dream_firebase_datasource.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/dream_repository.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/dreams_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamsModule extends Module {
  @override
  final List<Bind> binds = [

    Bind.lazySingleton((i) => DreamFirebaseDatasource()),
    Bind.lazySingleton((i) => DreamRespository(i.get<DreamFirebaseDatasource>())),
    Bind.lazySingleton((i) => DreamUseCase(i.get<DreamRespository>())),
    Bind.lazySingleton((i) => DreamsStore(i.get<DreamUseCase>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => DreamsPage()),
  ];
}

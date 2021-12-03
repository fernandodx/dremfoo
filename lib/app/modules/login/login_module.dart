import 'package:dremfoo/app/model/user.dart';
import 'package:dremfoo/app/modules/core/core_module.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/shared_prefs_repository.dart';
import 'package:dremfoo/app/modules/home/home_module.dart';
import 'package:dremfoo/app/modules/home/ui/pages/home_page.dart';
import 'package:dremfoo/app/modules/login/domain/stories/register_user_store.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/login_usecase.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/register_user_case.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/login_firebase_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/upload_files_firebase_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/datasources/user_firebase_datasource.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/RegisterUserRepository.dart';

import 'package:dremfoo/app/modules/login/infra/repositories/login_repository.dart';
import 'package:dremfoo/app/modules/login/domain/stories/login_store.dart';
import 'package:dremfoo/app/modules/login/ui/pages/login_page.dart';
import 'package:dremfoo/app/modules/login/ui/pages/register_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {

  @override
  final List<Module> imports = [
    CoreModule()
  ];


  @override
  final List<Bind> binds = [
    //Data Source
    Bind.lazySingleton((i) => LoginFirebaseDataSource(), export: true),
    Bind.lazySingleton((i) => UserFirebaseDataSource(), export: true),
    Bind.lazySingleton((i) => UploadFilesFirebaseDataSource(), export: true),

    //Repository
    Bind.lazySingleton((i) => RegisterUserRepository(i.get<LoginFirebaseDataSource>(), i.get<UploadFilesFirebaseDataSource>(), i.get<UserFirebaseDataSource>()), export: true),
    Bind.lazySingleton((i) => LoginRepository(i.get<LoginFirebaseDataSource>()), export: true),

    //UseCase
    Bind.lazySingleton((i) => LoginUseCase(i.get<LoginRepository>(), i.get<RegisterUserRepository>(), i.get<SharedPrefsRepository>()), export: true),
    Bind.lazySingleton((i) => RegisterUserCase(i.get<RegisterUserRepository>(), i.get<SharedPrefsRepository>()), export: true),

    //Store
    Bind.lazySingleton((i) => LoginStore(i.get<LoginUseCase>()), export: true),
    Bind.lazySingleton((i) => RegisterUserStore(i.get<RegisterUserCase>()), export: true),
    
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => LoginPage()),
    ChildRoute(REGISTER_PAGE, child: (_, args) => RegisterPage()),
    // ModuleRoute("/home", module: HomeModule()),
  ];

  static final String REGISTER_PAGE = "/register/user";
}

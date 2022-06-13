import 'package:dremfoo/app/modules/core/core_module.dart';
import 'package:dremfoo/app/modules/core/domain/usecases/SeoUserCase.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/shared_prefs_repository.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/upload_image_repository.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/archive_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/choice_type_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/detail_dream_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dream_completed_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/dream_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/register_dream_with_focus_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/stories/report_dream_week_store.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/dream_usecase.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/report_dream_usecase.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/dream_firebase_datasource.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/report_dream_datasource.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/dream_repository.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/report_dream_repository.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/archive_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/choice_type_dream_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/detail_dream_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/dream_completed_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/dreams_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/register_dream_wait_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/register_dream_with_focus_page.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/report_dream_page.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/register_user_case.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/RegisterUserRepository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DreamsModule extends Module {
  @override
  final List<Module> imports = [
    CoreModule(),
  ];

  @override
  final List<Bind> binds = [

    Bind.lazySingleton((i) => DreamFirebaseDatasource()),
    Bind.lazySingleton((i) => ReportDreamDataSource(), export: true),

    Bind.lazySingleton((i) => DreamRespository(i.get<DreamFirebaseDatasource>())),
    Bind.lazySingleton((i) => ReportDreamRepository(i.get<ReportDreamDataSource>()), export: true),

    Bind.lazySingleton((i) => DreamUseCase(i.get<DreamRespository>(), i.get<UploadImageRepository>(), i.get<SharedPrefsRepository>(), i.get<RegisterUserRepository>())),
    Bind.lazySingleton((i) => ReportDreamUseCase(i.get<ReportDreamRepository>()), export: true),

    Bind.lazySingleton((i) => DetailDreamStore(i.get<DreamUseCase>(), i.get<RegisterUserCase>(), i.get<SeoUserCase>())),
    Bind.lazySingleton((i) => RegisterDreamWithFocusStore(i.get<DreamUseCase>())),
    Bind.lazySingleton((i) => ChoiceTypeDreamStore()),
    Bind.lazySingleton((i) => DreamStore(i.get<DreamUseCase>())),
    Bind.lazySingleton((i) => ArchiveStore(i.get<DreamUseCase>())),
    Bind.lazySingleton((i) => DreamCompletedStore(i.get<DreamUseCase>())),
    Bind.lazySingleton((i) => ReportDreamWeekStore(i.get<ReportDreamUseCase>(), i.get<DreamUseCase>())),

  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => DreamsPage()),
    ChildRoute("/detail", child: (_, args) => DetailDreamPage(args.data)),
    ChildRoute("/choiceDream", child: (_, args) => ChoiceTypeDreamPage()),
    ChildRoute("/newDreamWait", child: (_, args) => RegisterDreamWaitPage()),
    ChildRoute("/newDreamWithFocus", child: (_, args) => RegisterDreamWithFocusPage(args.data)),
    ChildRoute("/archive", child: (_, args) => ArchivePage()),
    ChildRoute("/dreamsCompleted", child: (_, args) => DreamCompletedPage()),
    ChildRoute("/reportDreamWeek", child: (_, args) => ReportDreamPage(period: args.data,)),
  ];
}

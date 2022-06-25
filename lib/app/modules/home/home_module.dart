import 'package:dremfoo/app/app_module.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/report_dream_usecase.dart';
import 'package:dremfoo/app/modules/dreams/infra/datasources/report_dream_datasource.dart';
import 'package:dremfoo/app/modules/dreams/infra/repositories/report_dream_repository.dart';
import 'package:dremfoo/app/modules/home/domain/stories/daily_planning_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/free_videos_store.dart';
import 'package:dremfoo/app/modules/core/core_module.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/shared_prefs_repository.dart';
import 'package:dremfoo/app/modules/dreams/dreams_module.dart';
import 'package:dremfoo/app/modules/dreams/ui/pages/dreams_page.dart';
import 'package:dremfoo/app/modules/home/domain/stories/bottom_navigate_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/home_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/list_alert_report_goal_dream_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/prepare_next_day_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/presentation_daily_planning_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/rank_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/rate_of_the_day_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/social_network_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/splash_store.dart';
import 'package:dremfoo/app/modules/home/domain/stories/subscription_plan_store.dart';
import 'package:dremfoo/app/modules/home/domain/usecases/home_usecase.dart';
import 'package:dremfoo/app/modules/home/infra/datasources/home_datasource.dart';
import 'package:dremfoo/app/modules/home/infra/repositories/home_repository.dart';
import 'package:dremfoo/app/modules/home/ui/pages/bottom_navigate_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/daily_planning_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/free_videos_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/home_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/list_alert_report_goal_dream_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/prepare_next_day_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/presentation_daily_planning_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/rank_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/rate_of_the_day_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/social_network_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/splash_page.dart';
import 'package:dremfoo/app/modules/home/ui/pages/subscription_plan_page.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/contract/ilogin_case.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/login_usecase.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/register_user_case.dart';
import 'package:dremfoo/app/modules/login/infra/repositories/RegisterUserRepository.dart';
import 'package:dremfoo/app/modules/login/login_module.dart';
import 'package:dremfoo/app/modules/login/ui/pages/login_page.dart';
import 'package:dremfoo/app/modules/login/ui/pages/register_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  final List<Module> imports = [CoreModule(), DreamsModule(), LoginModule()];

  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeDataSource()),
    Bind.lazySingleton((i) => ReportDreamDataSource()),

    Bind.lazySingleton((i) => HomeRepository(i.get<HomeDataSource>())),
    Bind.lazySingleton((i) => ReportDreamRepository(i.get<ReportDreamDataSource>())),

    Bind.lazySingleton((i) => HomeUseCase(i.get<RegisterUserRepository>(),
        i.get<HomeRepository>(), i.get<SharedPrefsRepository>())),
    Bind.lazySingleton((i) => ReportDreamUseCase(i.get<ReportDreamRepository>(), i.get<RegisterUserRepository>())),

    Bind.lazySingleton((i) => RankStore(i.get<HomeUseCase>())),
    Bind.lazySingleton((i) => BottomNavigateStore()),
    Bind.lazySingleton((i) => SplashStore(i.get<LoginUseCase>(), i.get<RegisterUserCase>())),
    Bind.lazySingleton((i) => HomeStore(i.get<HomeUseCase>(), i.get<RegisterUserCase>(), i.get<LoginUseCase>(), i.get<ReportDreamUseCase>())),
    Bind.lazySingleton((i) => SocialNetworkStore()),
    Bind.lazySingleton((i) => SubscriptionPlanStore()),
    Bind.lazySingleton((i) => RateOfTheDayStore(i.get<HomeUseCase>())),
    Bind.lazySingleton((i) => PrepareNextDayStore(i.get<HomeUseCase>())),
    Bind.lazySingleton((i) => DailyPlanningStore(i.get<HomeUseCase>())),
    Bind.lazySingleton((i) => PresentationDailyPlanningStore(i.get<HomeUseCase>())),
    Bind.lazySingleton((i) => FreeVideosStore(i.get<HomeUseCase>())),
    Bind.lazySingleton((i) => ListAlertReportGoalDreamStore(i.get<ReportDreamUseCase>())),

  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SplashPage()),
    ModuleRoute("/userNotFound", module: LoginModule()),
    ChildRoute("/home", child: (_, args) => BottomNavigatePage(), children: [
      ChildRoute("/dashboard", child: (_, arg) => HomePage()),
      ModuleRoute("/dream", module: DreamsModule()),
      ChildRoute("/chart", child: (_, arg) => DreamsPage()),
      ChildRoute("/rank", child: (_, arg) => RankPage()),
      ChildRoute("/challenge", child: (_, arg) => RankPage()),
      ChildRoute("/subscriptionPlan", child: (_, arg) => SubscriptionPlanPage()),
      ChildRoute("/dailyPlanning", child: (_, arg) => DailyPlanningPage()),
      ChildRoute("/presentationDailyPlanning", child: (_, arg) => PresentationDailyPlanning()),
      ChildRoute("/prepareNextDay", child: (_, arg) => PrepareNextDayPage(dateSelected: arg.data,)),
      ChildRoute("/rateOfTheDay", child: (_, arg) => RateOfTheDayPage(dateSelected:  arg.data,)),
    ]),
    ModuleRoute("/dream", module: DreamsModule()),
    // ModuleRoute(LoginModule.REGISTER_PAGE, module: LoginModule(), ),
    ChildRoute("/editUser",
        child: (_, arg) => RegisterPage(
              userRevo: arg.data,
            )),
    ChildRoute("/socialNetwork", child: (_, arg) => SocialNetworkPage()),
    ChildRoute("/freeVideos", child: (_, arg) => FreeVideosPage()),
    ChildRoute("/notificationListGoals", child: (_, arg) => ListAlertReportGoalDreamPage()),
  ];
}

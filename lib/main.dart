import 'dart:convert';

import 'package:dremfoo/eventbus/user_event_bus.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/ui/login_page.dart';
import 'package:dremfoo/utils/analytics_util.dart';
import 'package:dremfoo/utils/crashlytics_util.dart';
import 'package:dremfoo/utils/remoteconfig_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'eventbus/main_event_bus.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await RemoteConfigUtil.init();
  CrashlyticsUtil.init();
  AnalyticsUtil.sendAnalyticsEvent(EventRevo.openApp);
  initConfigNotification();
  runApp(MyApp());
}

Future initConfigNotification() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        print("NOTIFICACAO IOS: ${body}, ${payload}");
        ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
      });

  var initializationSettings = InitializationSettings(
      android : initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    print("selectNotificationSubject : ${payload}");
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      var map = json.decode(payload);
      Utils.openUrl(map['url']);
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MainEventBus>(
          create: (context) => MainEventBus(),
          lazy: true,
          dispose: (context, mainEventBus) => mainEventBus.dispose(),
        ),
        Provider<UserEventBus>(
          create: (context) => UserEventBus(),
          lazy: true,
          dispose: (context, userEventBus) => userEventBus.dispose(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'REVO - Metas com foco',
        theme: ThemeData(
          fontFamily: "Alata",
          primaryColor: AppColors.colorPrimary,
          accentColor: AppColors.colorAcent,
          primaryColorDark: AppColors.colorPrimaryDark,
          canvasColor: Colors.transparent,
          buttonColor: AppColors.colorPrimaryDark,
          cardColor: AppColors.colorCard
        ),
         home: LoginPage(),
      ),
    );
  }



}




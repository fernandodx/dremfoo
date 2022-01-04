import 'dart:convert';

import 'package:dremfoo/app/app_module.dart';
import 'package:dremfoo/app/app_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/api/eventbus/main_event_bus.dart';
import 'app/api/eventbus/user_event_bus.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'app/ui/login_page.dart';
import 'app/utils/analytics_util.dart';
import 'app/utils/crashlytics_util.dart';
import 'app/utils/remoteconfig_util.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationAppLaunchDetails? notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await RemoteConfigUtil.init();
  CrashlyticsUtil.init();
  _initGoogleMobileAds();
  AnalyticsUtil.sendAnalyticsEvent(EventRevo.openApp);
  initConfigNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // runApp(MyApp());
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

Future<InitializationStatus> _initGoogleMobileAds() {
  return MobileAds.instance.initialize();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
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
          (int id, String? title, String? body, String? payload) async {
        print("NOTIFICACAO IOS: ${body}, ${payload}");
        ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
      });

  var initializationSettings = InitializationSettings(
      android : initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
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




import 'dart:io' show Platform;
import 'dart:ui';

import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/home_page_bloc.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/eventbus/user_event_bus.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/notification_revo.dart';
import 'package:dremfoo/model/push_notification.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/resources/constants.dart';
import 'package:dremfoo/ui/check_type_dream_page.dart';
import 'package:dremfoo/ui/register_dreams_page.dart';
import 'package:dremfoo/utils/crashlytics_util.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/notification_util.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:dremfoo/widget/app_button_default.dart';
import 'package:dremfoo/widget/app_drawer_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bloc = HomePageBloc();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    _bloc.fetch(context, true);

    MainEventBus().get(context).streamHomeDream.listen((TipoEvento tipo) {
      configMainEvent(tipo);
    });

    UserEventBus().get(context).stream.listen((TipoAcao tipo) {
      configUserEvent(tipo);
    });

    NotificationUtil.requestIOSPermissions();
    verifyNotification();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        PushNotification notification = PushNotification.fromMap(message);
        NotificationUtil.showNotification(notification.title, notification.message, paylod: notification.payload);
      },
      onLaunch: (Map<String, dynamic> message) async {
        PushNotification notification = PushNotification.fromMap(message);
        NotificationUtil.showNotification(notification.title, notification.message);
      },
      onResume: (Map<String, dynamic> message) async {
        PushNotification notification = PushNotification.fromMap(message);
        NotificationUtil.showNotification(notification.title, notification.message);
      },
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      //  print("FIREBASE MENSSAGE -> Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      // print("FIREBASE MENSSAGE -> $token");
    });
  }

  Future verifyNotification() async {
    UserRevo user = await FirebaseService().getPrefsUser();

    if (user != null) {
      if (user.isEnableNotification) {
        UserEventBus().get(context).sendEvent(TipoAcao.UPDATE_NOTIFICATION);
      } else {
        UserEventBus().get(context).sendEvent(TipoAcao.DISABLE_NOTIFICATION_DAILY_WEEKLY);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  void configMainEvent(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.FETCH:
        setState(() {
          _bloc.fetch(context, false);
        });
        break;

      case TipoEvento.REFRESH:
        setState(() {
          _bloc.fetch(context, false);
        });
        break;

      case TipoEvento.FETCH_WITH_LOADING:
        setState(() {
          _bloc.fetch(context, true);
        });
    }
  }

  Future configUserEvent(TipoAcao tipo) async {
    try {
      switch (tipo) {
        case TipoAcao.DISABLE_NOTIFICATION_DAILY_WEEKLY:
          NotificationUtil.deleteNotificationChannel(NotificationUtil.CHANNEL_NOTIFICATION_DAILY);
          // NotificationUtil.deleteNotificationChannel(NotificationUtil.CHANNEL_NOTIFICATION_WEEKLY);
          break;
        case TipoAcao.UPDATE_NOTIFICATION:
          UserRevo user = await FirebaseService().getPrefsUser();
          if (user != null && user.isEnableNotification) {
            NotificationUtil.deleteNotificationChannel(NotificationUtil.CHANNEL_NOTIFICATION_DAILY);
            // NotificationUtil.deleteNotificationChannel(NotificationUtil.CHANNEL_NOTIFICATION_WEEKLY);
            NotificationRevo initNotification = await _bloc.getNotificationRandomDailyInit();
            NotificationRevo finishNotification = await _bloc.getNotificationRandomDailyFinish();

            DateTime init = user.initNotification.toDate();
            DateTime finish = user.finishNotification.toDate();

            NotificationUtil.showDailyAtTime(
                Constants.ID_NOTIFICATION_INIT,
                initNotification.title,
                initNotification.msg,
                Time(init.hour, init.minute, init.second),
                NotificationUtil.ID_NOTIFICATION_DAILY,
                NotificationUtil.CHANNEL_NOTIFICATION_DAILY,
                NotificationUtil.DESCRIPTION_NOTIFICATION_DAILY);

            NotificationUtil.showDailyAtTime(
                Constants.ID_NOTIFICATION_FINISH,
                finishNotification.title,
                finishNotification.msg,
                Time(finish.hour, finish.minute, finish.second),
                NotificationUtil.ID_NOTIFICATION_DAILY,
                NotificationUtil.CHANNEL_NOTIFICATION_DAILY,
                NotificationUtil.DESCRIPTION_NOTIFICATION_DAILY);
          }
          break;
      }
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawerMenu(),
        body: Stack(
          children: <Widget>[bodyHomePage(), _bloc.loading()],
        ));
  }

  StreamBuilder<List<Dream>> bodyHomePage() {
    return StreamBuilder<List<Dream>>(
      stream: _bloc.streamDream,
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          return Container(
            child: TextUtil.textDefault(snapshots.error.toString()),
          );
        }

        if (snapshots.hasData) {
          List<Dream> listDream = snapshots.data;
          return _bodyMain(listDream);
        }

        return _bloc.getSimpleLoadingWidget();
      },
    );
  }

  Widget _bodyWithOutDreamHome() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              Utils.getPathAssetsImg("icon_start_dream.png"),
              width: 150,
              height: 150,
            ),
            SizedBox(
              height: 16,
            ),
            TextUtil.textDefault("Vamos começar sua jornada para realizar seus sonhos. Agora adicione o seu primeiro!",
                align: TextAlign.center, fontSize: 16),
            SizedBox(
              height: 20,
            ),
            AppButtonDefault(
              label: "Adicionar primeiro sonho",
              onPressed: () => _startRegisterDream(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyMain(List<Dream> listDreams) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          new SliverAppBar(
            pinned: false,
            title: TextUtil.textAppbar("Painel"),
          ),
        ];
      },
      body: getBody(listDreams),
    );
  }

  Widget getBody(List<Dream> listDreams) {
    if (listDreams == null || listDreams.isEmpty) {
      return _bodyWithOutDreamHome();
    } else {
      return _bodyDreams(listDreams);
    }
  }

  SingleChildScrollView _bodyDreams(List<Dream> listDreams) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: TextUtil.textTitulo("Sonhos"),
          ),
          Container(
            height: 185.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(8),
              children: _bloc.getlistCardDreamFire(context, listDreams),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: TextUtil.textTitulo("Etapas"),
          ),
          Container(
            margin: EdgeInsets.all(4),
            child: StreamBuilder(
              stream: _bloc.streamChipSteps,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(children: snapshot.data);
                }
                return _bloc.getSimpleLoadingWidget(size: 60);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: TextUtil.textTitulo("Metas diárias"),
          ),
          Stack(children: [
            Container(
              margin: EdgeInsets.all(4),
              child: StreamBuilder(
                  stream: _bloc.streamChipDailyGoal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(children: snapshot.data);
                    }

                    return _bloc.getSimpleLoadingWidget(size: 60);
                  }),
            ),
            StreamBuilder<bool>(
              stream: _bloc.streamCheckSucess,
              builder: (context, snapshot) {
                if(!snapshot.hasData || !snapshot.data){
                  return Container();
                }
                return Visibility(
                  visible: snapshot.data,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: Center(
                      child: FlareActor(
                        Utils.getPathAssetsAnim("animation_sucess-animate_check.flr"),
                        shouldClip: true,
                        animation: "animate_check",
                      ),
                    ),
                  ),
                );
              }
            ),
          ]),
          Container(
            height: 260.0,
            child: StreamBuilder<List<Widget>>(
              stream: _bloc.streamChartSteps,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(8),
                    children: snapshot.data,
                  );
                }
                return _bloc.getSimpleLoadingWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  _startRegisterDream(BuildContext context) async {
    push(context, CheckTypeDreamPage());
  }
}

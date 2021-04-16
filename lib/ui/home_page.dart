import 'dart:io' show Platform;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/api/firebase_service.dart';
import 'package:dremfoo/bloc/home_page_bloc.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/eventbus/user_event_bus.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/notification_revo.dart';
import 'package:dremfoo/model/push_notification.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/resources/app_colors.dart';
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
import 'package:dremfoo/extensions/util_extensions.dart';

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
        endDrawer: Drawer(
            child: Container(
          color: AppColors.colorEggShell,
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 24),
                    width: double.infinity,
                    height: 150,
                    child: FlareActor(
                      Utils.getPathAssetsAnim("medal.flr"),
                      shouldClip: true,
                      animation: "appear",
                      fit: BoxFit.contain,
                    ),
                  ),
                  TextUtil.textTitulo("Classificação"),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                color: AppColors.colorDark,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: FutureBuilder(
                    future: _bloc.getRankUsers(),
                    builder: (BuildContext context, AsyncSnapshot<List<UserRevo>> snapshots) {
                      if (snapshots.hasData) {
                        List<UserRevo> listRank = snapshots.data;

                        return ListView.builder(
                            itemCount: listRank.length,
                            itemBuilder: (context, index) {
                              UserRevo user = listRank[index];
                              String name = user.name != null ? user.name : user.email.split("@")[0];
                              String position = "${index + 1}˚";
                              String detailFocus = user.focus.countDaysFocus > 1
                                  ? "${user.focus.countDaysFocus} dias de foco"
                                  : "${user.focus.countDaysFocus} dia de foco";
                              return Container(
                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextUtil.textTitulo(position),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    SizedBox(
                                      child: CircleAvatar(
                                        radius: 34,
                                        backgroundImage: (user.urlPicture != null && user.urlPicture.isNotEmpty)
                                            ? NetworkImage(user.urlPicture)
                                            : AssetImage(Utils.getPathAssetsImg("icon_user_not_found.png")),
                                      ),
                                      width: 40,
                                      height: 40,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextUtil.textSubTitle(name.capitalizeFirstOfEach, fontWeight: FontWeight.bold),
                                        TextUtil.textSubTitle(detailFocus)
                                      ],
                                    ),
                                    Expanded(
                                      child: Visibility(
                                        visible: user.focus != null &&
                                            user.focus.level != null &&
                                            user.focus.level.urlIcon != null,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: CircleAvatar(
                                            radius: 13,
                                            backgroundColor: Colors.white12,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                width: 30,
                                                height: 30,
                                                imageUrl: user.focus.level.urlIcon,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }

                      if (snapshots.hasError) {
                        return Row(
                          children: [
                            Container(
                              child: TextUtil.textDefault(snapshots.error),
                            ),
                          ],
                        );
                      }

                      return _bloc.getSimpleLoadingWidget();
                    },
                  ),
                ),
              ),
            ],
          ),
        )),
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
              pinned: true,
              title: TextUtil.textAppbar(_bloc.titlePage),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.emoji_events_rounded),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
              bottom: PreferredSize(
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _bloc.getDaysOfWeekRow(context),
                  ),
                ),
                preferredSize: Size(double.infinity, 80),
              )),
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
            child: Row(
              children: [
                TextUtil.textTitulo("Etapas"),
                IconButton(
                    icon: _bloc.isVisibilityStep
                        ? Icon(
                            Icons.visibility_off,
                            color: AppColors.colorText,
                          )
                        : Icon(
                            Icons.visibility,
                            color: AppColors.colorText,
                          ),
                    onPressed: () {
                      setState(() {
                        _bloc.isVisibilityStep = !_bloc.isVisibilityStep;
                        _bloc.setVisibilityStepPrefs(_bloc.isVisibilityStep);
                      });
                    })
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(4),
            child: StreamBuilder(
              stream: _bloc.streamChipSteps,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Visibility(visible: _bloc.isVisibilityStep, child: Wrap(children: snapshot.data));
                }
                return _bloc.getSimpleLoadingWidget(size: 120);
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

                    return _bloc.getSimpleLoadingWidget(size: 120);
                  }),
            ),
            StreamBuilder<bool>(
                stream: _bloc.streamCheckSucess,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data) {
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
                }),
          ]),
          Container(
            key: Key("Chart"),
            height: 260.0,
            child: StreamBuilder<List<Widget>>(
              stream: _bloc.streamChartSteps,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    key: Key("LIST_${snapshot.data.length}"),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(8),
                    children: snapshot.data,
                  );
                }
                return Container();
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

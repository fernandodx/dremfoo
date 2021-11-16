import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/app/utils/date_util.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'eventbus/main_event_bus.dart';
import 'eventbus/user_event_bus.dart';
import 'package:dremfoo/app/model/color_dream.dart';
import 'package:dremfoo/app/model/daily_goal.dart';
import 'package:dremfoo/app/model/dream.dart';
import 'package:dremfoo/app/model/hist_goal_month.dart';
import 'package:dremfoo/app/model/hist_goal_week.dart';
import 'package:dremfoo/app/model/level_revo.dart';
import 'package:dremfoo/app/model/notification_revo.dart';
import 'package:dremfoo/app/model/response_api.dart';
import 'package:dremfoo/app/model/step_dream.dart';
import 'package:dremfoo/app/model/user.dart';
import 'package:dremfoo/app/model/user_focus.dart';
import 'package:dremfoo/app/model/video.dart';
import 'package:dremfoo/app/resources/constants.dart';
import 'package:dremfoo/app/resources/strings.dart';
import 'package:dremfoo/app/utils/analytics_util.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:dremfoo/app/utils/prefs.dart';
import 'package:dremfoo/app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_storage_service.dart';

String? fireBaseUserUid;

class FirebaseService {
  final _googleSign = GoogleSignIn();
  final _fbLogin = FacebookAuth.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> sendResetPassword(BuildContext context, String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<ResponseApi> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount account = await (_googleSign.signIn() as FutureOr<GoogleSignInAccount>);
      final GoogleSignInAuthentication authentication =
          await account.authentication;

      print("Google User: ${account.email}");
      AnalyticsUtil.sendLogLogin(MethodLogin.google);

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      return await _loginWithCredential(credential, context);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "Ops! Não foi possível realizar o login com a Google.");
    }
  }

  Future<ResponseApi<User>> _loginWithCredential(
      AuthCredential credential, BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithCredential(credential);
      final User user = await result.user!;
      await saveUser(context, user);
      MainEventBus().get(context).updateUser(user);
      return ResponseApi<User>.ok(result: user);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      if(error is FirebaseAuthException){
        FirebaseAuthException fbException = error as FirebaseAuthException;
        switch(fbException.code){
          case "account-exists-with-different-credential" :
            return ResponseApi.error(stackMessage: "Já existe uma conta com o mesmo endereço de e-mail, mas com credenciais de login diferentes. Faça login usando um provedor associado a este endereço de e-mail.");
        }
        return ResponseApi.error(stackMessage: error.toString());
      }else{
        return ResponseApi.error(stackMessage: error.toString());
      }
    }
  }

  Future<ResponseApi> loginWithFacebook(BuildContext context) async {
    try {
      String? msg = "";
      LoginResult result = await _fbLogin.login(permissions: ['email', 'public_profile']);
      switch(result.status){
        case LoginStatus.success: {
          AnalyticsUtil.sendLogLogin(MethodLogin.facebook);
          AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
          ResponseApi responseApi = await _loginWithCredential(credential, context);
          return responseApi;
        }
        case LoginStatus.cancelled: {
          msg = "Tudo bem, você pode utilizar outro método de login.";
          return ResponseApi.error(stackMessage: msg);
        }
        case LoginStatus.failed: {
          msg = result.message;
          return ResponseApi.error(stackMessage: msg);
        }
        case LoginStatus.operationInProgress:
          return ResponseApi.error(stackMessage: msg);
      }
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi> loginWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      AnalyticsUtil.sendLogLogin(MethodLogin.email);
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User user = await result.user!;
      MainEventBus().get(context).updateUser(user);
      saveUser(context, user);

      return ResponseApi<User>.ok(result: user);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = "Não foi possível autenticar o seu usuário.";

      if (error is PlatformException) {
        PlatformException exception = error as PlatformException;

        switch (exception.code) {
          case 'ERROR_INVALID_EMAIL':
            msg = Strings.msgErroEmailInvalid;
            break;
          case 'ERROR_USER_NOT_FOUND':
            msg = Strings.msgErroUserNotFound;
            break;
          case 'ERROR_WRONG_PASSWORD':
            msg = Strings.msgErroPasswordWrong;
            break;
          default:
            break;
        }
        print(
            "Login with Google COD: ${exception.code} MSG: ${exception.message}");
      } else {
        print("Login with Google error: $error");
      }
      return ResponseApi<User>.error(stackMessage: msg);
    }
  }

  Future<ResponseApi> updateUser(BuildContext context, {required name, urlPhoto}) async {
    try {
      var user = await FirebaseAuth.instance.currentUser!;
      if(urlPhoto != null){
        user.updateProfile(displayName: name, photoURL: urlPhoto);
      }else{
        user.updateProfile(displayName: name);
      }

      MainEventBus().get(context).updateUser(user);
      saveUser(context, user);

      return ResponseApi<User>.ok(result: user);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi<User>.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi> createUserWithEmailAndPassword(
      BuildContext context, String email, String password,
      {String? name, File? photo}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      User user = await result.user!;
      MainEventBus().get(context).updateUser(user);
      await saveUser(context, user);

      dynamic urlPhotoUser = null;
      if (photo != null) {
        urlPhotoUser = await FirebaseStorageService().uploadFileUserOn(photo, id: "user_photo");
      }
      if (name != null || urlPhotoUser != null) {
        await user.updateProfile(displayName: name, photoURL: urlPhotoUser);
      }

      var currentUser = await _auth.currentUser!;
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.registerNewUser, parameters: {
        "email": currentUser.email,
        "name": currentUser.displayName
      });

      return ResponseApi<User>.ok(result: currentUser);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      String msg = error.toString();
      if (error is PlatformException) {
        PlatformException exception = error as PlatformException;

        switch (exception.code) {
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            msg = Strings.msgErroEmailAlReadyInUse;
            break;
        }
      }
      if(error is FirebaseAuthException){
        FirebaseAuthException exception = error as FirebaseAuthException;

        switch (exception.code) {
          case 'email-already-in-use':
            msg = Strings.msgErroEmailAlReadyInUse;
            break;
        }
      }

      return ResponseApi<User>.error(stackMessage: msg);
    }
  }

  void setUidUser(uid) {
    if (uid != null) {
      fireBaseUserUid = uid;
    }
  }

  Future<bool> isUserUidExist(String uid) async {
    try{
      DocumentSnapshot snapshot = await getRefCurrentUser(uid).get();
      return snapshot.exists;
    }catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
      return false;
    }
  }

  DocumentReference getRefCurrentUser(String? uid) {
    return FirebaseFirestore.instance
        .collection(Constants.ENVIRONMENT)
        .doc(Constants.ENVIRONMENT_NOW)
        .collection("users").doc(uid);
  }


  Future<void> saveUser(BuildContext context, User user) async {
    if (user.email != null) {
      DateTime now = DateTime.now();
      DateTime initTime = DateTime(
          now.year, now.month, now.day, Constants.HOUR_INIT_NOTIFICATION);
      DateTime finishTime = DateTime(
          now.year, now.month, now.day, Constants.HOUR_FINISH_NOTIFICATION);

      try {
        await saveDataUser(user, initTime, finishTime);
        setUidUser(user.uid);
        savePrefsUser(context);
        saveLastAcess();
        checkFocusContinuos(context);
      } catch (error, stack) {
        CrashlyticsUtil.logErro(error, stack);
        print("ERRO AO SALVAR O USUARIO : $error");
      }
    }
  }

  Future<bool> saveDataUser(User user, DateTime initTime, DateTime finishTime) async {
     bool isExist = await isUserUidExist(user.uid);

    if(!isExist){
     getRefCurrentUser(user.uid).set({
        "name": user.displayName,
        "email": user.email,
        "urlPicture": user.photoURL,
        "isEnableNotification": Constants.IS_ENABLE_NOTIFICATION_DEFAULT,
        "initNotification": Timestamp.fromDate(initTime),
        "finishNotification": Timestamp.fromDate(finishTime)
      }).catchError((onError) => CrashlyticsUtil.logErro(onError, onError));
    }
    return isExist;
  }


  Future<UserFocus?> checkFocusContinuos(BuildContext context) async {

    ResponseApi<UserRevo> responseApi = await FirebaseService().findDataUser();
    if(responseApi.ok){
      UserFocus? focus = responseApi.result!.focus;
      if(focus != null && focus.dateLastFocus != null){
        DateTime dateLast = focus.dateLastFocus!.toDate();
        DateTime dateNow = DateTime.now();
        focus.level = LevelRevo();

        int countDayLast =  DateUtil().totalLengthOfDays(dateLast.month, dateLast.day, dateLast.year);
        int countDayNow=  DateUtil().totalLengthOfDays(dateNow.month, dateNow.day, dateNow.year);
        int count = countDayNow - countDayLast;

        ResponseApi<List<LevelRevo>> responseApi = await FirebaseService().findLevels(focus.countDaysFocus != null ? focus.countDaysFocus : 0);
        if(responseApi.ok) {
          List<LevelRevo>? listLevels = responseApi.result;
          if (listLevels != null && listLevels.length >= 1) {
            focus.level = listLevels[0];
            UserEventBus().get(context).updateLevel(focus);
            saveLevelPrefs(focus);
          }
        }

        if(count > 1){//mas que 1 dia que não executa uma meta
          //No Futuro alertar
          //Update data
          focus.dateInit = null;
          focus.countDaysFocus = 0;
        }
        FirebaseService().saveLastFocus(focus);
       return focus;
      }
    }else{
      return null;
    }

  }

  void saveLevelPrefs(UserFocus focus) {
    if(focus.level != null){
      Prefs.putString(Constants.LEVEL_NAME_USER, focus.level!.name!);
      Prefs.putString(Constants.LEVEL_URL_ICON, focus.level!.urlIcon!);
      Prefs.putInt(Constants.LEVEL_DAYS_FOCUS, focus.countDaysFocus!);
    }
  }

  Future<Map<String, dynamic>> getLevelsPrefs() async {
      Map<String, dynamic> map = Map();
      map[Constants.LEVEL_NAME_USER] = await Prefs.getString(Constants.LEVEL_NAME_USER);
      map[Constants.LEVEL_DAYS_FOCUS] = await Prefs.getInt(Constants.LEVEL_DAYS_FOCUS);
      map[Constants.LEVEL_URL_ICON] = await Prefs.getString(Constants.LEVEL_URL_ICON);

      return map;
  }

  ResponseApi<bool> updateConfigUser(bool? isEnableNotification,
      Timestamp? initNotification, Timestamp? finishNotification) {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);
      refUsers.update({
        "isEnableNotification": isEnableNotification,
        "initNotification": initNotification,
        "finishNotification": finishNotification
      });

      return ResponseApi.ok(result: true);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<UserRevo>> findDataUser() async {
    try {
      DocumentSnapshot snapshot = await getRefCurrentUser(fireBaseUserUid).get();
      UserRevo user = UserRevo.fromMap(snapshot.data() as Map<String, dynamic>);
      user.uid = snapshot.id;
      return ResponseApi.ok(result: user);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<List<NotificationRevo>>>
      findAllNotificationDailyInit() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("notificationsInitDaily")
          .get();
      List<NotificationRevo> list =
          NotificationRevo.fromListDocumentSnapshot(querySnapshot.docs);
      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<List<NotificationRevo>>>
      findAllNotificationDailyFinish() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("notificationsFinishDaily")
          .get();
      List<NotificationRevo> list =
          NotificationRevo.fromListDocumentSnapshot(querySnapshot.docs);
      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<List<Video>>> findAllVideos() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("videos")
          .orderBy("date", descending: true)
          .get();
      List<Video> list =
          Video.fromListDocumentSnapshot(querySnapshot.docs);
      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<List<LevelRevo>>> findLevels(int? value) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("levels")
          .where("finishValue", isGreaterThanOrEqualTo: value)
          .orderBy("finishValue", descending: false)
          .get();
      List<LevelRevo> list = LevelRevo.fromListDocumentSnapshot(querySnapshot.docs);
      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<List<ColorDream>>> findAllColorsDream() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("colorsDreams").get();
      List<ColorDream> list =
          ColorDream.fromListDocumentSnapshot(querySnapshot.docs);
      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  void savePrefsUser(BuildContext context) async {
    ResponseApi responseApi = await findDataUser();
    if (responseApi.ok) {
      UserRevo user = responseApi.result;
      Prefs.putString("USER_PREF_UID", user.uid!);
      Prefs.putString("USER_PREF_NAME", user.name!);
      Prefs.putString("USER_PREF_EMAIL", user.email!);
      Prefs.putString("USER_PREF_URL_PICTURE", user.urlPicture!);
      Prefs.putBool("USER_PREF_ISNOTIFICATION", user.isEnableNotification!);
      Prefs.putInt("USER_PREF_INIT_NOTIFICATION",
          user.initNotification!.toDate().millisecondsSinceEpoch);
      Prefs.putInt("USER_PREF_FINISH_NOTIFICATION",
          user.finishNotification!.toDate().millisecondsSinceEpoch);
      setUserProperties(user);
      CrashlyticsUtil.addUserIdentifier(user);
    }
  }

  void setUserProperties(UserRevo user) {
    AnalyticsUtil.setUserProperty("uid", user.uid);
    AnalyticsUtil.setUserProperty("name", user.name);
    AnalyticsUtil.setUserProperty("email", user.email);
    AnalyticsUtil.setUserProperty("urlPicture", user.urlPicture);
    AnalyticsUtil.setUserProperty(
        "initNotification", Utils.dateToString(user.initNotification!.toDate()));
    AnalyticsUtil.setUserProperty("finishNotification",
        Utils.dateToString(user.finishNotification!.toDate()));
    AnalyticsUtil.setUserProperty(
        "isEnableNotification", user.isEnableNotification.toString());
  }

  Future<UserRevo?> getPrefsUser() async {
    int timeInit = await Prefs.getInt("USER_PREF_INIT_NOTIFICATION");
    int timeFinish = await Prefs.getInt("USER_PREF_FINISH_NOTIFICATION");
    String uid = await Prefs.getString("USER_PREF_UID");

    if (uid == null || uid.isEmpty) {
      return null;
    }

    UserRevo user = UserRevo();
    user.uid = uid;
    user.name = await Prefs.getString("USER_PREF_NAME");
    user.email = await Prefs.getString("USER_PREF_EMAIL");
    user.urlPicture = await Prefs.getString("USER_PREF_URL_PICTURE");
    user.isEnableNotification = await Prefs.getBool("USER_PREF_ISNOTIFICATION", false);
    user.initNotification = Timestamp.fromMillisecondsSinceEpoch(timeInit);
    user.finishNotification = Timestamp.fromMillisecondsSinceEpoch(timeFinish);
    setUserProperties(user);
    CrashlyticsUtil.addUserIdentifier(user);

    return user;
  }

  void removeUserPref() {
    Prefs.removePref("USER_PREF_UID");
    Prefs.removePref("USER_PREF_NAME");
    Prefs.removePref("USER_PREF_EMAIL");
    Prefs.removePref("USER_PREF_URL_PICTURE");
    Prefs.removePref("USER_PREF_ISNOTIFICATION");
    Prefs.removePref("USER_PREF_INIT_NOTIFICATION");
    Prefs.removePref("USER_PREF_FINISH_NOTIFICATION");
  }

  Future<bool> checkLoginOn() async {
    UserRevo? user = await getPrefsUser();
    if (user != null) {
      setUidUser(user.uid);
      saveLastAcess();
      return true;
    }

    return false;
  }

  Future<ResponseApi<List<Dream>>> findAllDreams() async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      QuerySnapshot querySnapshot = await refUsers
          .collection("dreams")
          .where("isDeleted", isEqualTo: false)
          .where("dateFinish", isNull: true)
          .get()
          .catchError((error) => CrashlyticsUtil.logErro(error, error));

      return ResponseApi.ok(result: Dream.fromListDocumentSnapshot(querySnapshot.docs));
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<UserRevo>>> findRankUser() async {
    try {

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Constants.ENVIRONMENT)
          .doc(Constants.ENVIRONMENT_NOW)
          .collection("users")
          .where("focus.countDaysFocus", isGreaterThan: 0)
          .orderBy("focus.countDaysFocus", descending: true)
          .get()
          .catchError((error) {
            CrashlyticsUtil.logErro(error, error);
          }
      );

      List<UserRevo> listUsers = UserRevo.fromListDocumentSnapshot(querySnapshot.docs);
      listUsers = listUsers.where((user) => user.focus != null && user.focus!.level != null).toList();

      return ResponseApi.ok(result: listUsers);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<Dream>>> findAllDreamsCompleted() async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      QuerySnapshot querySnapshot = await refUsers
          .collection("dreams")
          .where("dateFinish", isLessThanOrEqualTo: Timestamp.now())
          .get();

      return ResponseApi.ok(
          result: Dream.fromListDocumentSnapshot(querySnapshot.docs));
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<Dream>>> findAllDreamsDeleted() async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      QuerySnapshot querySnapshot = await refUsers
          .collection("dreams")
          .where("isDeleted", isEqualTo: true)
          .get();

      return ResponseApi.ok(
          result: Dream.fromListDocumentSnapshot(querySnapshot.docs));
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<Dream>>> findDreamsGoalWeekOk() async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      QuerySnapshot querySnapshot = await refUsers
          .collection("dreams")
          .where("isGoalWeekOk", isEqualTo: true)
          .get();

      List<Dream> list =
          Dream.fromListDocumentSnapshot(querySnapshot.docs);
      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  ResponseApi<CollectionReference> findSteps(Dream dream) {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      CollectionReference listStepsRef =
          refUsers.collection("dreams").doc(dream.uid).collection("steps");

      return ResponseApi.ok(result: listStepsRef);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<StepDream>>> findAllStepsForDream(Dream dream) async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      QuerySnapshot querySnapshot = await refUsers
          .collection("dreams")
          .doc(dream.uid)
          .collection("steps")
          .orderBy("position")
          .get();

      List<StepDream> list =
          StepDream.fromListDocumentSnapshot(querySnapshot.docs);

      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  void saveLastAcess() {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      refUsers.collection("hits").add({"dateAcess": Timestamp.now()});
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      print("$error");
    }
  }

  Future<bool> isExistAcessPreviousMonth() async {
    try {
      DateTime date = DateTime.now();
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      Timestamp firdDayMonth =
          Timestamp.fromDate(DateTime(date.year, date.month, 1));

      QuerySnapshot query = await refUsers
          .collection("hits")
          .where("dateAcess", isLessThan: firdDayMonth)
          .get();

      return query.docs.isNotEmpty;
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      print("$error");
      return false;
    }
  }

  Future<int> getCountHitsUser() async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      QuerySnapshot query = await refUsers
          .collection("hits")
          .get();
      return query.size;

    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      print("$error");
      return 0;
    }
  }

  Future<DateTime?> getLastHitUser() async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      QuerySnapshot query = await refUsers
          .collection("hits")
          .orderBy("dateAcess", descending: true)
          .limit(2)
          .get();

     List<QueryDocumentSnapshot> list = query.docs;

     if(list == null || list.isEmpty){
       return DateTime.now();
     }

     int index = list.length > 1 ? 1 : 0;
     Timestamp dateLastAcess = list[index].get('dateAcess');
     return dateLastAcess.toDate();

    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      print("$error");
      return null;
    }
  }

  ResponseApi<CollectionReference> findDailyGoals(Dream dream) {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      CollectionReference listStepsRef = refUsers
          .collection("dreams")
          .doc(dream.uid)
          .collection("dailyGoals");

      return ResponseApi.ok(result: listStepsRef);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<DailyGoal>>> findDailyGoalsCompletedHist(
      Dream dream, DateTime dateStart, DateTime dateEnd) async {
    try {
      DocumentReference dreamRef = dream.reference!;
      Timestamp start = Timestamp.fromDate(
          DateTime(dateStart.year, dateStart.month, dateStart.day));
      Timestamp end = Timestamp.fromDate(
          DateTime(dateEnd.year, dateEnd.month, dateEnd.day)
              .add(Duration(days: 1)));

      QuerySnapshot query = await dreamRef
          .collection("dailyCompletedHist")
          .where("lastDateCompleted", isGreaterThanOrEqualTo: start)
          .where("lastDateCompleted", isLessThanOrEqualTo: end)
          .get();

      List<DailyGoal> list = DailyGoal.fromListDocumentSnapshot(query.docs);
      return ResponseApi.ok(result: list);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<Dream>> findDream(String dreamPropouse) async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      DocumentSnapshot dreamRef =
          await refUsers.collection("dreams").doc(dreamPropouse).get();

      return ResponseApi.ok(result: Dream.fromMap(dreamRef.data));
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<StepDream>>> findStepsForDream(
      String dreamPropouse) async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      CollectionReference listStepsRef = refUsers
          .collection("dreams")
          .doc(dreamPropouse)
          .collection("steps");

      List<StepDream> listSteps = [];
      QuerySnapshot querySnapshot = await listStepsRef.get();

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        listSteps.add(StepDream.fromMap(snapshot.data()));
      }

      return ResponseApi.ok(result: listSteps);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<bool>> findStepToday(String nameStep) async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      DateTime dateTime = DateTime.now();

      DocumentSnapshot listStepsRef = await refUsers
          .collection("stepsCompletedToday")
          .doc("${dateTime.year}-${dateTime.month}-${dateTime.day}")
          .collection("steps")
          .doc(nameStep)
          .get();

      return ResponseApi.ok(result: listStepsRef.exists);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  ResponseApi<Void> updateStepToday(String nameStep, bool isSelected) {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      DateTime dateTime = DateTime.now();

      DocumentReference stepCompleted = refUsers
          .collection("stepsCompletedToday")
          .doc("${dateTime.year}-${dateTime.month}-${dateTime.day}")
          .collection("steps")
          .doc(nameStep);

      stepCompleted.set({"isOK": true});

      if (!isSelected) {
        stepCompleted.delete();
      }

      return ResponseApi.ok();
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  ResponseApi<bool> updateStepDream(StepDream stepDream) {
    try {
      DocumentReference stepUpdate = stepDream.reference;
      stepUpdate.set(stepDream.toMap());

      return ResponseApi.ok(result: true);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<bool>> updateDailyGoal(DailyGoal dailyGoal) async {
    try {
      DocumentReference dailyRef = dailyGoal.reference;
      dailyGoal.uid = dailyRef.id;

      dailyRef.set(dailyGoal.toMap());

      DocumentReference dreamRef = dailyRef.parent.parent!;
      CollectionReference histRef = dreamRef.collection("dailyCompletedHist");

      if (dailyGoal.lastDateCompleted != null) {
        histRef.add(dailyGoal.toMap());
        return ResponseApi.ok(result: true);
      } else {
        DateTime now = DateTime.now();
        DateTime date = Utils.stringToDate("${now.year}-${now.month}-${now.day}");
        QuerySnapshot query =
            await histRef
                .where("uid", isEqualTo: dailyGoal.uid)
                .where("lastDateCompleted", isGreaterThan: Timestamp.fromDate(date))
                .get();
        for (QueryDocumentSnapshot snapshot in query.docs) {
          if (snapshot.exists) {
            snapshot.reference.delete();
          }
        }
        return ResponseApi.ok(result: true);
      }
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<DocumentReference>> updateDream(
      BuildContext context, Dream dream) async {
    try {
      DocumentReference dreamRef = dream.reference!;
      dreamRef.update(dream.toMap());

      CollectionReference stepsListRef = dreamRef.collection("steps");
      CollectionReference dailyGoalRef = dreamRef.collection("dailyGoals");

      QuerySnapshot queryStep = await stepsListRef.get();
      QuerySnapshot queryDaily = await dailyGoalRef.get();

      List<StepDream> stepsOld = [];
      List<DailyGoal> dailysOld = [];


      for (QueryDocumentSnapshot stepOld in queryStep.docs) {
        StepDream step = StepDream.fromMap(stepOld.data());
        step.reference = stepOld.reference;

        stepsOld.add(step);
        if (!dream.steps!.contains(step)) {
          step.reference.delete();
        }
      }

      for (QueryDocumentSnapshot dailyOld in queryDaily.docs) {
        DailyGoal daily = DailyGoal.fromMap(dailyOld.data());
        daily.reference = dailyOld.reference;

        dailysOld.add(daily);
        if (!dream.dailyGoals.contains(daily)) {
          daily.reference.delete();
        }
      }

      for (StepDream stepDream in dream.steps!) {
        if (!stepsOld.contains(stepDream)) {
          stepsListRef.add(stepDream.toMap());
        } else {
          int index = stepsOld.indexOf(stepDream);

          StepDream dreamCurrent = stepsOld[index];
          dreamCurrent.position = stepDream.position;
          dreamCurrent.reference.set(dreamCurrent.toMap());
        }
      }

      for (DailyGoal dailyGoal in dream.dailyGoals) {
        if (!dailysOld.contains(dailyGoal)) {
          dailyGoalRef.add(dailyGoal.toMap());
        } else {
          int index = dailysOld.indexOf(dailyGoal);

          DailyGoal dailyCurrent = dailysOld[index];
          dailyCurrent.position = dailyGoal.position;
          dailyCurrent.reference.set(dailyCurrent.toMap());
        }
      }

      return ResponseApi.ok(result: dreamRef);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<String>> saveDream(BuildContext context, Dream dream) async {
    try {
      dream.dateRegister = Timestamp.now();

      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      DocumentReference dreamRef = await refUsers.collection("dreams").add(dream.toMap());
      CollectionReference stepsListRef = dreamRef.collection("steps");
      CollectionReference dailyGoalRef = dreamRef.collection("dailyGoals");

      for (StepDream stepDream in dream.steps!) {
        stepsListRef.add(stepDream.toMap());
      }

      for (DailyGoal dailyGoal in dream.dailyGoals) {
        dailyGoalRef.add(dailyGoal.toMap());
      }

      return ResponseApi.ok(result: dreamRef.id);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<bool>> isStatusStepCompleted(
      StepDream stepDream, DateTime date) async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      DocumentReference dreamRef = refUsers
          .collection("dreams")
          .doc(stepDream.dreamParent.dreamPropose);

      CollectionReference stepsListRef = dreamRef.collection("steps");
      DocumentReference stepRef = stepsListRef.doc(stepDream.step);

      CollectionReference statusDreamListHistRef = stepRef.collection("years");

      DocumentSnapshot histRef = await statusDreamListHistRef
          .doc("${date.year}")
          .collection("mouth") //Arrumar esse cara
          .doc("${date.month}")
          .collection("days")
          .doc("${date.day}")
          .get();

      return ResponseApi.ok(result: histRef.exists);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  Future<ResponseApi<List<int>>> findDaysStepCompletedForMonth(
      StepDream stepDream, DateTime date) async {
    try {
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);

      DocumentReference dreamRef = refUsers
          .collection("dreams")
          .doc(stepDream.dreamParent.dreamPropose);

      CollectionReference stepsListRef = dreamRef.collection("steps");
      DocumentReference stepRef = stepsListRef.doc(stepDream.step);

      CollectionReference statusDreamListHistRef = stepRef.collection("years");

      QuerySnapshot histRef = await statusDreamListHistRef
          .doc("${date.year}")
          .collection("mouth") //Arrumar esse cara
          .doc("${date.month}")
          .collection("days")
          .get();

      List<int> listDays = [];
      histRef.docs.forEach((daySnapshot) {
        listDays.add(int.parse(daySnapshot.id));
      });

      return ResponseApi.ok(result: listDays);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: "$error");
    }
  }

  logout() {
    _auth.signOut();
    _googleSign.signOut();
  }

  void updateOnlyField(String field, value, DocumentReference ref) {
    ref.update({field: value});
  }

  void updateDataDream(Dream dream) {
    dream.reference!.update(dream.toMap());
  }

  Future<HistGoalWeek> saveHistWeekCompleted(
      Dream dream, DateTime firsDayWeek, bool isWonReward) async {
    var hist = HistGoalWeek();
    hist.firsDayWeek = Timestamp.fromDate(firsDayWeek);
    hist.numberWeek = Utils.getNumberWeek(firsDayWeek);
    hist.difficulty = dream.goalWeek;
    hist.reward = dream.reward;
    hist.inflection = dream.inflection;
    hist.isWonReward = isWonReward;
    hist.isNeedInflection = !isWonReward;
    hist.isShow = false;
    hist.dateLastShow = Timestamp.now();

    DocumentReference refHist = await dream.reference!.collection("histGoalWeekReached").add(hist.toMap());
    hist.dream = dream;
    hist.reference = refHist;

    return hist;
  }

  void saveHistMonthCompleted(Dream dream, DateTime date, bool isWonReward) {
    var hist = HistGoalMonth();
    hist.dateCompleted = Timestamp.fromDate(date);
    hist.numberMonth = date.month;
    hist.difficulty = dream.goalWeek;
    hist.reward = dream.reward;
    hist.inflection = dream.inflection;
    hist.isWonReward = isWonReward;
    hist.isNeedInflection = !isWonReward;
    hist.isShow = false;

    dream.reference!.collection("histGoalMonthReached").add(hist.toMap());
  }

  Future<ResponseApi<HistGoalMonth>> findHistShowedForMonth(Dream dream, int numberMonth) async {
    try {
      Query query = dream.reference!
          .collection("histGoalMonthReached")
          .where("isShow", isEqualTo: true)
          .where("numberMonth", isEqualTo: numberMonth)
          .orderBy("dateCompleted", descending: true);

      // Query query = dream.reference
      //     .collection("histGoalWeekReached");
      //     .where("isShow", isEqualTo: true)
      //      .where("numberWeek", isEqualTo: numberMonth) //46
      //      .orderBy("firsDayWeek", descending: true);

      if (query != null) {
        QuerySnapshot querySnapshot = await query.get();
        List<HistGoalMonth> list =
        HistGoalMonth.fromListDocumentSnapshot(querySnapshot.docs);
        if (list != null && list.isNotEmpty) {
          HistGoalMonth hist = list[0];
          hist.dream = dream;
          return ResponseApi.ok(result: hist);
        }
      }
      return ResponseApi.ok(result: null);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<HistGoalMonth>> findLastHistMonth(Dream dream,
      {bool isShow = false}) async {
    try {
      Query query = dream.reference!
          .collection("histGoalMonthReached")
          .where("isShow", isEqualTo: isShow)
          .orderBy("numberMonth", descending: true);

      if (query != null) {
        QuerySnapshot querySnapshot = await query.get();
        List<HistGoalMonth> list =
            HistGoalMonth.fromListDocumentSnapshot(querySnapshot.docs);
        if (list != null && list.isNotEmpty) {
          HistGoalMonth hist = list[0];
          hist.dream = dream;
          return ResponseApi.ok(result: hist);
        }
      }
      return ResponseApi.ok(result: null);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<HistGoalWeek>> findLastHistWeekWithDate(Dream dream,
      {bool isShow = false, Timestamp? date}) async {
    try {
      Query query;
      if(date != null){
        DateTime initDate = Utils.stringToDate("${date.toDate().year}-${Utils.addZeroLeft(date.toDate().month)}-${Utils.addZeroLeft(date.toDate().day)} 00:00:00");
        DateTime finishDate = Utils.stringToDate("${date.toDate().year}-${Utils.addZeroLeft(date.toDate().month)}-${Utils.addZeroLeft(date.toDate().day)} 23:59:59");

        query = dream.reference!
            .collection("histGoalWeekReached")
            .where("isShow", isEqualTo: isShow)
            .where("dateLastShow", isLessThanOrEqualTo: Timestamp.fromDate(finishDate))
            .where("dateLastShow", isGreaterThanOrEqualTo: Timestamp.fromDate(initDate))
            .limit(1);
      }else{
        query = dream.reference!
            .collection("histGoalWeekReached")
            .where("isShow", isEqualTo: isShow)
            .orderBy("numberWeek", descending: true)
            .limit(1);
      }

      if (query != null) {
        QuerySnapshot querySnapshot = await query.get();
        List<HistGoalWeek> list =
            HistGoalWeek.fromListDocumentSnapshot(querySnapshot.docs);
        if (list != null && list.isNotEmpty) {
          HistGoalWeek hist = list[0];
          hist.dream = dream;
          return ResponseApi.ok(result: hist);
        }
      }
      return ResponseApi.ok(result: null);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  ResponseApi<bool> deleteDream(Dream dream) {
    try {
      updateOnlyField("isDeleted", true, dream.reference!);
      return ResponseApi.ok(result: true);
    } catch (error, stack) {
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

  Future<ResponseApi<bool>> saveLastFocus(UserFocus userFocus) async {

    try{
      DocumentReference refUsers = getRefCurrentUser(fireBaseUserUid);
      refUsers.update({"focus" : userFocus.toMap()})
          .catchError((error) => CrashlyticsUtil.logErro(error, error));

      return ResponseApi.ok(result: true);

    }catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
      return ResponseApi.error(stackMessage: error.toString());
    }
  }

}

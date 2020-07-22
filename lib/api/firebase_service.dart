import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/model/chart_goals.dart';
import 'package:dremfoo/model/daily_goal.dart';
import 'package:dremfoo/model/dream.dart';
import 'package:dremfoo/model/hist_goal_month.dart';
import 'package:dremfoo/model/hist_goal_week.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/model/step_dream.dart';
import 'package:dremfoo/model/user.dart';
import 'package:dremfoo/model/video.dart';
import 'package:dremfoo/resources/strings.dart';
import 'package:dremfoo/utils/prefs.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_storage_service.dart';

String fireBaseUserUid;

class FirebaseService {
  final _googleSign = GoogleSignIn();
  final _fbLogin = FacebookLogin();
  final _auth = FirebaseAuth.instance;

  Future<void> sendResetPassword(BuildContext context, String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<ResponseApi> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount account = await _googleSign.signIn();
      final GoogleSignInAuthentication authentication =
          await account.authentication;

      print("Google User: ${account.email}");

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: authentication.idToken,
          accessToken: authentication.accessToken);
      return await _loginWithCredential(credential, context);
    } catch (error) {
      print("Login with Google error: $error");
      return ResponseApi.error(msg: error.toString());
    }
  }

  Future<ResponseApi<FirebaseUser>> _loginWithCredential(
      AuthCredential credential, BuildContext context) async {
    AuthResult result = await _auth.signInWithCredential(credential);
    final FirebaseUser user = await result.user;
    MainEventBus().get(context).updateUser(user);
    saveUser(context, user);
    print("Login realizado com sucesso!!!");
    print("Nome: ${user.displayName}");
    print("E-mail: ${user.email}");
    print("Foto: ${user.photoUrl}");

    return ResponseApi<FirebaseUser>.ok(result: user);
  }

  Future<ResponseApi> loginWithFacebook(BuildContext context) async {
    try {
      FacebookLoginResult result =
          await _fbLogin.logIn(['email', 'public_profile']);
      String msg = "";

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          return await _loginWithCredential(credential, context);
          break;

        case FacebookLoginStatus.cancelledByUser:
          msg = "Tudo bem, você pode utilizar outro método de login.";
          return ResponseApi.error(msg: msg);
          break;
        case FacebookLoginStatus.error:
          msg = result.errorMessage;
          return ResponseApi.error(msg: msg);
          break;
      }
    } catch (error) {
      print("Login with Google error: $error");
      return ResponseApi.error(msg: error.toString());
    }
  }

  Future<ResponseApi> loginWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser user = await result.user;
      MainEventBus().get(context).updateUser(user);
      print("Login realizado com sucesso!!!");
      print("Nome: ${user.displayName}");
      print("E-mail: ${user.email}");
      print("Foto: ${user.photoUrl}");
      saveUser(context, user);

      return ResponseApi<FirebaseUser>.ok(result: user);
    } catch (error) {
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
      return ResponseApi<FirebaseUser>.error(msg: msg);
    }
  }

  Future<ResponseApi> updateUser(BuildContext context, {name, urlPhoto}) async {
    try {
      final updateUser = UserUpdateInfo();
      if (urlPhoto != null) {
        updateUser.photoUrl = urlPhoto;
      }
      updateUser.displayName = name ?? "";

      var user = await FirebaseAuth.instance.currentUser();
      MainEventBus().get(context).updateUser(user);
      user.updateProfile(updateUser);
      saveUser(context, user);

      return ResponseApi<FirebaseUser>.ok(result: user);
    } catch (error) {
      print("Erro ao atualizar o usuário: ${error}");
      return ResponseApi<FirebaseUser>.error(msg: error.toString());
    }
  }

  Future<ResponseApi> createUserWithEmailAndPassword(
      BuildContext context, String email, String password,
      {String name, File photo}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = await result.user;
      MainEventBus().get(context).updateUser(user);
      saveUser(context, user);

      var urlPhotoUser = null;

      if (photo != null) {
        urlPhotoUser = await FirebaseStorageService()
            .uploadFileUserOn(photo, id: "user_photo");
      }

      if (name != null || urlPhotoUser != null) {
        final updateUser = UserUpdateInfo();
        updateUser.photoUrl = urlPhotoUser;
        updateUser.displayName = name ?? "";
        await user.updateProfile(updateUser);
      }

      var currentUser = await _auth.currentUser();

      return ResponseApi<FirebaseUser>.ok(result: currentUser);
    } catch (error) {
      String msg = error.toString();
      if (error is PlatformException) {
        PlatformException exception = error as PlatformException;

        switch (exception.code) {
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            msg = Strings.msgErroEmailAlReadyInUse;
            break;
        }

        print(
            "Erro ao criar o usuário: cod - ${error.code} mensagem - ${error.message}");
      }

      return ResponseApi<FirebaseUser>.error(msg: msg);
    }
  }

  void setUidUser(uid) {
    if (uid != null) {
      fireBaseUserUid = uid;
    }
  }

  void saveUser(BuildContext context, FirebaseUser user) {
    if (user.displayName != null && user.email != null) {
      try {
        Firestore.instance
            .collection("users")
            .document(user.uid)
            .setData({"name": user.displayName, "e-mail": user.displayName});
        savePrefsUser(user);
        setUidUser(user.uid);
        saveLastAcess();
      } catch (error) {
        print("ERRO AO SALVAR O USUARIO : $error");
      }
    }
  }
  
  Future<ResponseApi<List<Video>>> findAllVideos() async{
    try{
      QuerySnapshot querySnapshot =  await Firestore.instance.collection("videos").orderBy("date", descending: true).getDocuments();
      List<Video> list = Video.fromListDocumentSnapshot(querySnapshot.documents);
      return ResponseApi.ok(result: list);
    }catch(error){
      print("ERRO AO CONSULTAR VIDEOS : $error");
      return ResponseApi.error(msg: error.toString());
    }
  }

  void savePrefsUser(FirebaseUser user) {
    List<String> listData = List();
    listData.add(user.uid);
    listData.add(user.displayName);
    listData.add(user.email);
    listData.add(user.photoUrl);

    Prefs.putListString("USER_PREF", listData);
  }

  Future<User> getPrefsUser() async {
    List<String> listData = await Prefs.getListString("USER_PREF");

    if (listData == null || listData.isEmpty) {
      return null;
    }

    User user = User();
    user.uid = listData[0];
    user.name = listData[1];
    user.email = listData[2];
    user.urlPicture = listData[3];

    return user;
  }

  void removeUserPref() {
    Prefs.removePref("USER_PREF");
  }

  Future<bool> checkLoginOn() async {
    User user = await getPrefsUser();
    if (user != null) {
      setUidUser(user.uid);
      saveLastAcess();
      return true;
    }

    return false;
  }

  ResponseApi<CollectionReference> findDreams() {
    try {
      DocumentReference refUsers =
          Firestore.instance.collection("users").document(fireBaseUserUid);

      CollectionReference listDreamRef = refUsers.collection("dreams");

      return ResponseApi.ok(result: listDreamRef);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<List<Dream>>> findDreamsGoalWeekOk() async {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      QuerySnapshot querySnapshot =  await refUsers.collection("dreams")
          .where("isGoalWeekOk", isEqualTo: true)
          .getDocuments();

      List<Dream> list = Dream.fromListDocumentSnapshot(querySnapshot.documents);
      return ResponseApi.ok(result: list);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  ResponseApi<CollectionReference> findSteps(Dream dream) {
    try {
      DocumentReference refUsers =
          Firestore.instance.collection("users").document(fireBaseUserUid);

      CollectionReference listStepsRef = refUsers
          .collection("dreams")
          .document(dream.uid)
          .collection("steps");

      return ResponseApi.ok(result: listStepsRef);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  void saveLastAcess() {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      refUsers.collection("hits").add({"dateAcess": Timestamp.now()});
    } catch (error) {
      print("$error");
    }
  }

  Future<bool> isExistAcessPreviousMonth() async {
    try {
      DateTime date = DateTime.now();
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      Timestamp firdDayMonth = Timestamp.fromDate(DateTime(date.year, date.month, 1));

      QuerySnapshot query = await refUsers.collection("hits")
                                  .where("dateAcess", isLessThan: firdDayMonth)
                                  .getDocuments();

      return query.documents.isNotEmpty;

    } catch (error) {
      print("$error");
      return false;
    }
  }

  ResponseApi<CollectionReference> findDailyGoals(Dream dream) {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      CollectionReference listStepsRef = refUsers
          .collection("dreams")
          .document(dream.uid)
          .collection("dailyGoals");

      return ResponseApi.ok(result: listStepsRef);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<List<DailyGoal>>> findDailyGoalsCompletedHist(Dream dream, DateTime dateStart, DateTime dateEnd) async {
    try {
      DocumentReference dreamRef = dream.reference;
      Timestamp start = Timestamp.fromDate(DateTime(dateStart.year, dateStart.month, dateStart.day));
      Timestamp end = Timestamp.fromDate(DateTime(dateEnd.year, dateEnd.month, dateEnd.day).add(Duration(days: 1)));

      QuerySnapshot query = await dreamRef.collection("dailyCompletedHist")
                            .where("lastDateCompleted", isGreaterThanOrEqualTo: start)
                            .where("lastDateCompleted", isLessThanOrEqualTo: end)
                            .getDocuments();

      List<DailyGoal> list = List();

      for(DocumentSnapshot snapshot in query.documents){
        list.add(DailyGoal.fromMap(snapshot.data));
      }

      return ResponseApi.ok(result: list);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<Dream>> findDream(String dreamPropouse) async {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      DocumentSnapshot dreamRef = await refUsers.collection("dreams")
                                               .document(dreamPropouse).get();

      return ResponseApi.ok(result: Dream.fromMap(dreamRef.data));
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<List<StepDream>>> findStepsForDream(String dreamPropouse) async {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      CollectionReference listStepsRef = refUsers
          .collection("dreams")
          .document(dreamPropouse)
          .collection("steps");

       List<StepDream> listSteps = List();
       QuerySnapshot querySnapshot = await listStepsRef.getDocuments();

       for(DocumentSnapshot snapshot in querySnapshot.documents){
          listSteps.add(StepDream.fromMap(snapshot.data));
       }

      return ResponseApi.ok(result: listSteps);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<bool>> findStepToday(String nameStep) async {
    try {
      DocumentReference refUsers =
          Firestore.instance.collection("users").document(fireBaseUserUid);

      DateTime dateTime = DateTime.now();

      DocumentSnapshot listStepsRef =  await refUsers
          .collection("stepsCompletedToday")
          .document("${dateTime.year}-${dateTime.month}-${dateTime.day}")
          .collection("steps")
      .document(nameStep).get();

      return ResponseApi.ok(result: listStepsRef.exists);

    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  ResponseApi<Void> updateStepToday(String nameStep, bool isSelected) {
    try {
      DocumentReference refUsers =
          Firestore.instance.collection("users").document(fireBaseUserUid);

      DateTime dateTime = DateTime.now();

      DocumentReference stepCompleted = refUsers
          .collection("stepsCompletedToday")
          .document("${dateTime.year}-${dateTime.month}-${dateTime.day}")
          .collection("steps")
          .document(nameStep);

      stepCompleted.setData({"isOK": true});

      if (!isSelected) {
        stepCompleted.delete();
      }

      return ResponseApi.ok();
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  ResponseApi<Void> updateStepDream(StepDream stepDream) {
    try {

      DocumentReference stepUpdate = stepDream.reference;
      stepUpdate.setData(stepDream.toMap());

      return ResponseApi.ok();
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<Void>> updateDailyGoal(DailyGoal dailyGoal) async {
    try {

      DocumentReference dailyRef = dailyGoal.reference;
      dailyGoal.uid = dailyRef.documentID;

      dailyRef.setData(dailyGoal.toMap());

      DocumentReference dreamRef = dailyRef.parent().parent();
      CollectionReference histRef = dreamRef.collection("dailyCompletedHist");

      if(dailyGoal.lastDateCompleted != null){
        histRef.add(dailyGoal.toMap());
      }else{
        QuerySnapshot query = await histRef.where("uid", isEqualTo: dailyGoal.uid).getDocuments();
        for(DocumentSnapshot snapshot in query.documents){
          if(snapshot.exists){
            snapshot.reference.delete();
          }
        }
      }

      return ResponseApi.ok();
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }


  Future<ResponseApi<DocumentReference>> updateDream(BuildContext context, Dream dream) async {
    try {

      DocumentReference dreamRef = dream.reference;
      dreamRef.updateData(dream.toMap());

      CollectionReference stepsListRef = dreamRef.collection("steps");
      CollectionReference dailyGoalRef = dreamRef.collection("dailyGoals");

      QuerySnapshot queryStep = await stepsListRef.getDocuments();
      QuerySnapshot queryDaily = await dailyGoalRef.getDocuments();

      List<StepDream> stepsOld = List();
      List<DailyGoal> dailysOld = List();

      for(DocumentSnapshot stepOld in queryStep.documents){
        StepDream step = StepDream.fromMap(stepOld.data);
        step.reference = stepOld.reference;

        stepsOld.add(step);
        if(!dream.steps.contains(step)){
          step.reference.delete();
        }
      }

      for(DocumentSnapshot dailyOld in queryDaily.documents){
        DailyGoal daily = DailyGoal.fromMap(dailyOld.data);
        daily.reference = dailyOld.reference;

        dailysOld.add(daily);
        if(!dream.dailyGoals.contains(daily)){
          daily.reference.delete();
        }
      }

      for(StepDream stepDream in dream.steps){
        if(!stepsOld.contains(stepDream)){
          stepsListRef.add(stepDream.toMap());
        }else{
          int index = stepsOld.indexOf(stepDream);

          StepDream dreamCurrent = stepsOld[index];
          dreamCurrent.position = stepDream.position;
          dreamCurrent.reference.setData(dreamCurrent.toMap());
        }
      }

      for(DailyGoal dailyGoal in dream.dailyGoals){
        if(!dailysOld.contains(dailyGoal)){
          dailyGoalRef.add(dailyGoal.toMap());
        }else{
          int index = dailysOld.indexOf(dailyGoal);

          DailyGoal dailyCurrent = dailysOld[index];
          dailyCurrent.position = dailyGoal.position;
          dailyCurrent.reference.setData(dailyCurrent.toMap());
        }
      }

      return ResponseApi.ok(result: dreamRef);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }


  Future<ResponseApi<String>> saveDream(BuildContext context, Dream dream) async {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      DocumentReference dreamRef = await refUsers.collection("dreams").add(dream.toMap());
      CollectionReference stepsListRef = dreamRef.collection("steps");
      CollectionReference dailyGoalRef = dreamRef.collection("dailyGoals");

      for(StepDream stepDream in dream.steps){
        stepsListRef.add(stepDream.toMap());
      }

      for(DailyGoal dailyGoal in dream.dailyGoals){
        dailyGoalRef.add(dailyGoal.toMap());
      }

      return ResponseApi.ok(result: dreamRef.documentID);
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<bool>> isStatusStepCompleted(StepDream stepDream, DateTime date) async {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      DocumentReference dreamRef =
      refUsers.collection("dreams").document(stepDream.dreamPropose);

      CollectionReference stepsListRef = dreamRef.collection("steps");
      DocumentReference stepRef = stepsListRef.document(stepDream.step);

      CollectionReference statusDreamListHistRef = stepRef.collection("years");

      DocumentSnapshot histRef = await statusDreamListHistRef
          .document("${date.year}")
          .collection("mouth") //Arrumar esse cara
          .document("${date.month}")
          .collection("days")
          .document("${date.day}").get();

      return ResponseApi.ok(result: histRef.exists);
      
    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  Future<ResponseApi<List<int>>> findDaysStepCompletedForMonth(StepDream stepDream, DateTime date) async {
    try {
      DocumentReference refUsers =
      Firestore.instance.collection("users").document(fireBaseUserUid);

      DocumentReference dreamRef =
      refUsers.collection("dreams").document(stepDream.dreamPropose);

      CollectionReference stepsListRef = dreamRef.collection("steps");
      DocumentReference stepRef = stepsListRef.document(stepDream.step);

      CollectionReference statusDreamListHistRef = stepRef.collection("years");

      QuerySnapshot histRef = await statusDreamListHistRef
          .document("${date.year}")
          .collection("mouth") //Arrumar esse cara
          .document("${date.month}")
          .collection("days").getDocuments();

      List<int> listDays = List();
      histRef.documents.forEach((daySnapshot){
        listDays.add(int.parse(daySnapshot.documentID));
      });

      return ResponseApi.ok(result: listDays);

    } catch (error) {
      return ResponseApi.error(msg: "$error");
    }
  }

  logout() {
    _auth.signOut();
    _googleSign.signOut();
  }

  void updateOnlyField(String field, value,  DocumentReference ref) {
    ref.updateData({
       field: value
    });
  }

  void updateDataDream(Dream dream) {
    dream.reference.updateData(dream.toMap());
  }

  void saveHistWeekCompleted(Dream dream, DateTime firsDayWeek, bool isWonReward) {
    var hist = HistGoalWeek();
    hist.firsDayWeek = Timestamp.fromDate(firsDayWeek);
    hist.numberWeek = Utils.getNumberWeek(firsDayWeek);
    hist.difficulty = dream.goalWeek;
    hist.reward = dream.reward;
    hist.inflection = dream.inflection;
    hist.isWonReward = isWonReward;
    hist.isNeedInflection = !isWonReward;
    hist.isShow = false;
    
    dream.reference.collection("histGoalWeekReached").add(hist.toMap());
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

    dream.reference.collection("histGoalMonthReached").add(hist.toMap());
  }

  Future<ResponseApi<HistGoalMonth>> findLastHistMonth(Dream dream, {bool isShow = false}) async {
    try{

      Query query = dream.reference.collection("histGoalMonthReached")
          .where("isShow", isEqualTo: isShow)
          .orderBy("numberMonth", descending: true);

      if(query != null){
        QuerySnapshot querySnapshot = await query.getDocuments();
        List<HistGoalMonth> list = HistGoalMonth.fromListDocumentSnapshot(querySnapshot.documents);
        if(list != null && list.isNotEmpty){
          HistGoalMonth hist = list[0];
          hist.dream = dream;
          return ResponseApi.ok(result: hist);
        }
      }
      return ResponseApi.ok(result: null);

    }catch(error){
      ResponseApi.error(msg: error.toString());
    }
  }

  Future<ResponseApi<HistGoalWeek>> findLastHistWeek(Dream dream, {bool isShow = false}) async {
    try{

      Query query = dream.reference.collection("histGoalWeekReached")
          .where("isShow", isEqualTo: isShow)
          .orderBy("numberWeek", descending: true);

      if(query != null){
        QuerySnapshot querySnapshot = await query.getDocuments();
        List<HistGoalWeek> list = HistGoalWeek.fromListDocumentSnapshot(querySnapshot.documents);
        if(list != null && list.isNotEmpty){
          HistGoalWeek hist = list[0];
          hist.dream = dream;
          return ResponseApi.ok(result: hist);
        }
      }
      return ResponseApi.ok(result: null);

    }catch(error){
      ResponseApi.error(msg: error.toString());
    }
  }


}

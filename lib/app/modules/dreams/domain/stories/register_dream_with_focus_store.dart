
import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/utils/analytics_util.dart';
import 'package:dremfoo/app/modules/core/domain/utils/revo_analytics.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/color_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/daily_goal.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/entities/step_dream.dart';
import 'package:dremfoo/app/modules/dreams/domain/usecases/contract/idream_case.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/ui/register_dreams_page.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/search_picture_internet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'register_dream_with_focus_store.g.dart';

class RegisterDreamWithFocusStore = _RegisterDreamWaitStoreBase with _$RegisterDreamWithFocusStore;
abstract class _RegisterDreamWaitStoreBase with Store {

  @observable
  bool isLoading = false;

  @observable
  MessageAlert? msgAlert;

  @observable
  int currentStep = 0;

  @observable
  Dream dream = Dream();

  @observable
  ObservableList<bool> listInfoExpanted = ObservableList<bool>.of([]);

  @observable
  ObservableList<Widget> listStepsForWin = ObservableList<Widget>.of([]);

  @observable
  ObservableList<Widget> listDailyGoals = ObservableList<Widget>.of([]);

  @observable
  ObservableList<ColorDream> listColorDream = ObservableList<ColorDream>.of([]);

  @observable
  ObservableSet<int> stepErrors = ObservableSet<int>.of([]);

  List<Step> steps = [];

  TextEditingController stepTextEditController = TextEditingController();
  TextEditingController dailyGoalTextEditController = TextEditingController();
  TextEditingController dreamTextEditController = TextEditingController();
  TextEditingController dreamDescriptionTextEditController = TextEditingController();
  TextEditingController rewardTextEditController = TextEditingController();
  TextEditingController rewardWeekTextEditController = TextEditingController();
  TextEditingController inflectionTextEditController = TextEditingController();
  TextEditingController inflectionWeekTextEditController = TextEditingController();

  IDreamCase _dreamCase;
  _RegisterDreamWaitStoreBase(this._dreamCase);

  @action
  void setImageDream(String imgDreamBase64){
    Dream tmp = Dream.copy(dream);
    tmp.imgDream = imgDreamBase64;
    dream = tmp;
  }

  @action
  void addStepInDream(StepDream step){
    Dream tmp = Dream.copy(dream);
    if(tmp.steps == null ){
      tmp.steps = [];
    }
    tmp.steps?.add(step);
    dream = tmp;
  }

  @action
  void addDailyGoalInDream(DailyGoal daily){
    Dream tmp = Dream.copy(dream);
    if(tmp.dailyGoals == null ){
      tmp.dailyGoals = [];
    }
    tmp.dailyGoals?.add(daily);
    dream = tmp;
  }

  @action
  void changeIsRewardWeekDream(bool isRewardWeek){
    Dream tmp = Dream.copy(dream);
    if(tmp.isRewardWeek == null ){
      tmp.isRewardWeek = false;
    }
    tmp.isRewardWeek = isRewardWeek;
    dream = tmp;
  }

  @action
  void changeIsInflectionWeekDream(bool isInflectionWeek){
    Dream tmp = Dream.copy(dream);
    if(tmp.isInflectionWeek == null ){
      tmp.isInflectionWeek = false;
    }
    tmp.isInflectionWeek = isInflectionWeek;
    dream = tmp;
  }

  @action
  void changeGoalWeekDream(double valueGoalWeek){
    Dream tmp = Dream.copy(dream);
    if(tmp.goalWeek == null ){
      tmp.goalWeek = 0;
    }
    tmp.goalWeek = valueGoalWeek;
    dream = tmp;
  }

  @action
  void changeGoalMonthDream(double valueGoalMonth){
    Dream tmp = Dream.copy(dream);
    if(tmp.goalMonth == null ){
      tmp.goalMonth = 0;
    }
    tmp.goalMonth = valueGoalMonth;
    dream = tmp;
  }

  @action
  void changeColorDream(ColorDream colorDream){
    Dream tmp = Dream.copy(dream);
    if(tmp.color == null ){
      tmp.color = ColorDream.fromMap({
        "primary": "FF6E5773",
        "secondary": "FF382C3A"
      });
    }
    tmp.color = colorDream;
    dream = tmp;
  }

  @action
  void setListInfoExpanted(List<bool> listInfo) {
    listInfoExpanted = ObservableList.of(listInfo);
  }

  @action
  void setListColorDream(List<ColorDream> listColor) {
    listColorDream = ObservableList.of(listColor);
  }

  @action
  void addItemStepForWin(Widget step) {
    listStepsForWin.add(step);
  }

  @action
  void addItemDailyGoal(Widget step) {
    listDailyGoals.add(step);
  }

  @action
  void removeStepForWin(position) {

    var countWidgetDefault = 2;
    var positionTrue = position - countWidgetDefault;
    var positionWithOutDefaultWidget = positionTrue < 0 ? 0 : positionTrue;

    listStepsForWin.removeAt(positionWithOutDefaultWidget);
    List<Widget> stepTmp = List.of(listStepsForWin);

    _reCreateListStepsReOrderPosition(stepTmp);
  }

  @computed
  bool get isLastStepCurrent {
    return currentStep == steps.length -1;
  }

  @action
  Future<void> finishRegisterDream() async {
    setDataDream();

    if (validDataStream()) {
      isLoading = true;
      if (dream.reference == null) {
        await _saveDream();
      } else {
        await _editDream();
      }
      isLoading = false;
    }
  }

  void nextStep() {
    if(isLastStepCurrent){
      finishRegisterDream();
    }else{
      goToStep(currentStep + 1);
    }
  }

  void cancelStep() {
    if (currentStep > 0) {
      goToStep(currentStep - 1);
    }
  }

  @action
  void goToStep(numberStep) {
    currentStep = numberStep;
  }

  Future<void> _saveDream() async {
    ResponseApi<Dream> responseApi = await _dreamCase.saveDream(dream);
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      Modular.to.navigate(Modular.initialRoute);
    }
  }

  Future<void> _editDream() async {
     ResponseApi<Dream> responseApi = await _dreamCase.updateDream(dream);
     msgAlert = responseApi.messageAlert;
     if(responseApi.ok){
       Modular.to.navigate(Modular.initialRoute);
     }
  }

  void setDataDream() {
    dream.dreamPropose = dreamTextEditController.text.toString();
    dream.reward = rewardTextEditController.text.toString();
    dream.inflection = inflectionTextEditController.text.toString();
    dream.rewardWeek = rewardWeekTextEditController.text.toString();
    dream.inflectionWeek = inflectionWeekTextEditController.text.toString();
    dream.descriptionPropose = dreamDescriptionTextEditController.text.toString();
  }

  @action
  bool validDataStream() {
    String msg = "";

    stepErrors = ObservableSet<int>.of([]);;

    if (dream.dreamPropose == null || dream.dreamPropose?.isEmpty == true) {
      stepErrors.add(StepsEnum.DREAM.index);
      msg += "O sonho é obrigatório\n";
    }

    if (dream.descriptionPropose == null || dream.descriptionPropose?.isEmpty == true) {
      stepErrors.add(StepsEnum.DREAM.index);
      msg += "A descrição do sonho é obrigatória\n";
    }

    if (dream.imgDream == null || dream.imgDream?.isEmpty == true) {
      stepErrors.add(StepsEnum.DREAM.index);
      msg += "A image do sonho é obrigatória\n";
    }

    if (!dream.isDreamWait!) {
      if (dream.steps == null || dream.steps?.isEmpty == true) {
        stepErrors.add(StepsEnum.STEPS.index);
        msg += "Adicione pelo menos um passo para conquistar\n";
      }

      if (dream.dailyGoals == null || dream.dailyGoals?.isEmpty == true) {
        stepErrors.add(StepsEnum.DAILY_GOALS.index);
        msg += "Adicione pelo menos uma meta diária\n";
      }

      if (dream.reward == null || dream.reward?.isEmpty == true) {
        stepErrors.add(StepsEnum.REWARD.index);
        msg += "A recompensa é obrigatória\n";
      }

      if (dream.inflection == null || dream.inflection?.isEmpty == true) {
        stepErrors.add(StepsEnum.INFLECTION.index);
        msg += "O ponto de inflexão é obrigatório\n";
      }
    }

    if (dream.color == null) {
      stepErrors.add(StepsEnum.CONFIG.index);
      msg += "Escolha uma cor de representação\n";
    }

    if (stepErrors.isNotEmpty) {
      msgAlert = MessageAlert.create("Ops", msg, TypeAlert.ERROR);
      return false;
    }

    return true;
  }

  void removeDailyGoals(position) {

    var countWidgetDefault = 2;
    var positionTrue = position - countWidgetDefault;
    var positionWithOutDefaultWidget = positionTrue < 0 ? 0 : positionTrue;

    listDailyGoals.removeAt(positionWithOutDefaultWidget);
    List<Widget> dailyTmp = List.of(listDailyGoals);

    _reCreateListDailyGoalReOrderPosition(dailyTmp);

  }

  bool checkStepActive(StepsEnum stepsEnum){
    return currentStep >= stepsEnum.index;
  }

  StepState getStateStep(StepsEnum stepsEnum) {
    if (stepErrors.contains(stepsEnum.index)) {
      return StepState.error;
    }

    if (currentStep > stepsEnum.index) {
      return StepState.complete;
    } else {
      return StepState.indexed;
    }
  }

  Future<void> loadImageGallery(BuildContext context) async {
    ResponseApi<String> responseApi = await _dreamCase.loadImageDreamGallery();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      setImageDream(responseApi.result!);
    }
    Navigator.pop(context);
  }

  Future<void> loadListColorDream() async {
    ResponseApi<List<ColorDream>> responseApi = await _dreamCase.findAllColorsDream();
    msgAlert = responseApi.messageAlert;
    if(responseApi.ok){
      setListColorDream(responseApi.result!);
    }
  }

  SearchPictureInternet searchImageInternet(BuildContext context) {
    String sonho = dreamTextEditController.text;
    if(sonho.isNotEmpty && sonho.contains(" ")){
      sonho = sonho.split(" ").last;
    }
    SearchPictureInternet search = SearchPictureInternet(sonho);
    search.stream.listen((String fotoBase64) {
      setImageDream(fotoBase64);
      Navigator.pop(context);
      AnalyticsUtil.sendAnalyticsEvent(EventRevo.addImageDreamInternet);
    });
    return search;
  }

  @action
  Future<void> fetch(BuildContext context, Dream? dreamEdit, bool isWait) async {
    isLoading = true;
    loadListColorDream();

    if (dreamEdit == null) {
      _initNewDream(isWait);
    } else {
      _initDreamForEdit(dreamEdit);
      await _loadStepsDream(dreamEdit);
      await _loadDailyGoalDream(dreamEdit);
    }
    isLoading = false;
  }

  Future<void> _loadDailyGoalDream(Dream dreamEdit) async {
     ResponseApi<List<DailyGoal>> responseApiDailyGoal = await _dreamCase.findDailyGoalForUser(dreamEdit.uid!);
    if(responseApiDailyGoal.ok){
      dream.dailyGoals = responseApiDailyGoal.result!;
      _createListDailyGoalWithDreamDaily(responseApiDailyGoal.result!);
    }
  }

  Future<void> _loadStepsDream(Dream dreamEdit) async {
     ResponseApi<List<StepDream>> responseApiStepDream = await _dreamCase.findStepDreamForUser(dreamEdit.uid!);
    if(responseApiStepDream.ok){
      dream.steps = responseApiStepDream.result!;
      _createListStepsWithDreamSteps(responseApiStepDream.result!);
    }
  }

  void _initDreamForEdit(Dream dreamEdit) {
     dream = Dream.copy(dreamEdit);
    dreamTextEditController.text = dream.dreamPropose!;
    rewardTextEditController.text = dream.reward!;
    inflectionTextEditController.text = dream.inflection!;
    dreamDescriptionTextEditController.text = dream.descriptionPropose!;
    inflectionWeekTextEditController.text = dream.inflectionWeek!;
    rewardWeekTextEditController.text = dream.rewardWeek!;
  }

  void _initNewDream(bool isWait) {
     dream = Dream();
    dream.isDreamWait = isWait;
    dream.steps = [];
    steps = [];
  }

  void _reCreateListStepsReOrderPosition(List<Widget> listStepsOld){
    listStepsForWin.clear();
    dream.steps?.clear();

    for (var position = 0; position < listStepsOld.length; position++) {
      Chip chip = listStepsOld[position] as Chip;
      Text text = chip.label as Text;
      int positionView = position + 1;

      StepDream sd = StepDream();
      sd.step = text.data;
      sd.position = positionView;
      addStepInDream(sd);

      var newChip = createChipStep(
          nameStep: text.data??"",
          position: positionView,
          onDeleted: () {
            removeStepForWin(position);
          });

      addItemStepForWin(newChip);
    }
  }

  void _createListStepsWithDreamSteps(List<StepDream> listStepDream){
    for (StepDream stepDream in listStepDream) {
      var newChip = createChipStep(
          nameStep: stepDream.step??"",
          position: stepDream.position??0,
          onDeleted: () {
            removeStepForWin(stepDream.position??0);
          });
      addItemStepForWin(newChip);
    }
  }

  void _createListDailyGoalWithDreamDaily(List<DailyGoal> listDailyGoal){
    for (DailyGoal daily in listDailyGoal) {
      var newChip = createChipStep(
          nameStep: daily.nameDailyGoal??"",
          position: daily.position??0,
          onDeleted: () {
            removeStepForWin(daily.position??0);
          });
      addItemDailyGoal(newChip);
    }
  }

  void _reCreateListDailyGoalReOrderPosition(List<Widget> listDailyOld){
    listDailyGoals.clear();
    dream.dailyGoals?.clear();

    for (var position = 0; position < listDailyOld.length; position++) {
      Chip chip = listDailyOld[position] as Chip;
      Text text = chip.label as Text;
      int positionView = position + 1;

      DailyGoal dg = DailyGoal();
      dg.nameDailyGoal = text.data;
      dg.position = positionView;
      addDailyGoalInDream(dg);

      var newChip = createChipStep(
          nameStep: text.data??"",
          position: positionView,
          onDeleted: () {
            removeDailyGoals(position);
          });

      addItemDailyGoal(newChip);
    }
  }



  List<Widget> addStepForWinOnly(String nameStep, int position, BuildContext context) {
    if (nameStep.isNotEmpty) {
      var newChip = Chip(
        avatar: CircleAvatar(
          backgroundColor: AppColors.colorChipSecundary,
          child: TextUtil.textChip('${position - 1}˚', maxLines: 1),
        ),
        label: TextUtil.textChip(nameStep, maxLines: 1),
        backgroundColor: AppColors.colorChipPrimary,
        onDeleted: () => removeStepForWin(position),
        deleteIconColor: Colors.white,
      );

      StepDream sd = StepDream();
      sd.step = nameStep;
      sd.position = position;
      dream.steps!.add(sd);

      listStepsForWin.add(newChip);
    }
    return [];
  }

  Chip createChipStep({
    required String nameStep,
    required int position,
    Function()? onDeleted}) {

    return Chip(
      avatar: CircleAvatar(
        backgroundColor: AppColors.colorChipSecundary,
        child: TextUtil.textChip('${position}˚', maxLines: 1),
      ),
      label: TextUtil.textChip(nameStep, maxLines: 1),
      backgroundColor: AppColors.colorChipPrimary,
      onDeleted: onDeleted,
      deleteIconColor: Colors.white,
    );

  }

  void addStepForWin(String? nameStep, int position) {
    if (nameStep == null || nameStep.isEmpty) {
      return;
    }

    var newChip = createChipStep(
        nameStep: nameStep,
        position: position,
        onDeleted: () {
          removeStepForWin(position);
        });

    StepDream sd = StepDream();
    sd.step = nameStep;
    sd.position = position;
    addStepInDream(sd);

    stepTextEditController.clear();
    addItemStepForWin(newChip);
    AnalyticsUtil.sendAnalyticsEvent(EventRevo.addStepforDream);
  }

  void addDailyGoals(String? nameGoal, int position) {

    if (nameGoal == null || nameGoal.isEmpty) {
      return;
    }

    var newChip = createChipStep(
        nameStep: nameGoal,
        position: position,
        onDeleted: () {
          removeDailyGoals(position);
        });

    DailyGoal dg = DailyGoal();
    dg.nameDailyGoal = nameGoal;
    dg.position = position;
    addDailyGoalInDream(dg);

    dailyGoalTextEditController.clear();
    addItemDailyGoal(newChip);
    AnalyticsUtil.sendAnalyticsEvent(EventRevo.addDailyForDream);
  }

}
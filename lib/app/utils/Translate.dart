import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'AppContext.dart';

class Translate  {

  static Translate? _instance;
  late AppLocalizations _appLocalizations;

  Translate._internal();

  static Translate i() {
    if(_instance == null){
      _instance = Translate._internal();
    }
    return _instance!;
  }

  init(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get get => _appLocalizations;



}

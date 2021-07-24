import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'AppContext.dart';

class Translate  {
  static AppLocalizations text(){
    return AppLocalizations.of(AppContext.contextKey.currentContext);
  }
}

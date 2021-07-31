

import 'package:flutter/material.dart';

class AppContext  {

  static AppContext? _instance;
  late BuildContext _context;

  AppContext._internal();

  static AppContext getInstance() {
    if (_instance == null) {
      _instance = AppContext._internal();
    }
    return _instance!;
  }

  BuildContext get context => _context;

  set context(BuildContext value) {
    _context = value;
  }
}

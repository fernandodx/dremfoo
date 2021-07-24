
import 'package:flutter/material.dart';

abstract class ILoginDatasource {

  Future<void> sendResetPassword(String email);

}
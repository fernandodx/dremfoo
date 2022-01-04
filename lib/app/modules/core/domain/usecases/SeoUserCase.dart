import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';
import 'package:dremfoo/app/modules/core/domain/entities/response_api.dart';
import 'package:dremfoo/app/modules/core/domain/entities/type_alert.dart';
import 'package:dremfoo/app/modules/core/domain/usecases/contract/iseo_user_case.dart';
import 'package:dremfoo/app/modules/core/infra/repositories/contract/ishared_prefs_repository.dart';
import 'package:dremfoo/app/modules/login/domain/exceptions/revo_exceptions.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/crashlytics_util.dart';
import 'package:flutter/material.dart';

class SeoUserCase implements ISeoUserCase {

  ISharedPrefsRepository _sharedPrefsRepository;
  SeoUserCase(this._sharedPrefsRepository);

  @override
  Future<bool> isCanShowReviewApp() async {

    int dateEpoch = await _sharedPrefsRepository.getInt("DATE_REVIEW");

    if(dateEpoch == 0) {
      return true;
    }

    DateTime dateReview = DateTime.fromMillisecondsSinceEpoch(dateEpoch);
    dateReview = DateUtils.addDaysToDate(dateReview, 30);

    if(DateTime.now().isAfter(dateReview)){
      return true;
    }else{
      return false;
    }
  }

  @override
  Future<ResponseApi> saveLastDateReviewApp(DateTime date) async {
    try{

      await _sharedPrefsRepository.putInt("DATE_REVIEW", date.millisecondsSinceEpoch);
      return ResponseApi.ok();

    } on RevoExceptions catch(error){
      var alert = MessageAlert.create(Translate.i().get.title_msg_error, error.msg, TypeAlert.ERROR);
      return ResponseApi.error(stackMessage: error.stack.toString(), messageAlert: alert);
    } catch(error, stack){
      CrashlyticsUtil.logErro(error, stack);
    }

    var alert = MessageAlert.create(Translate.i().get.title_msg_error, Translate.i().get.msg_error_unexpected, TypeAlert.ERROR);
    return ResponseApi.error(messageAlert: alert);
  }

}
import 'package:dremfoo/app/modules/login/domain/entities/error_msg.dart';

class ResponseApi<T> {

  bool ok;
  String stackMessage;
  MessageAlert messageAlert;
  T result;

  ResponseApi.ok({this.result, this.messageAlert}){
    ok = true;
  }

  ResponseApi.error({this.stackMessage, this.messageAlert}){
    ok = false;
  }

}
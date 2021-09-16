import 'package:dremfoo/app/modules/core/domain/entities/error_msg.dart';

class ResponseApi<T> {

  late bool ok;
  String? stackMessage;
  MessageAlert? messageAlert;
  T? result;

  ResponseApi.ok({this.result, this.messageAlert}){
    ok = true;
  }

  ResponseApi.error({this.stackMessage, required this.messageAlert}){
    ok = false;
  }

}
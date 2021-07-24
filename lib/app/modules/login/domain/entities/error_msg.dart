import 'package:dremfoo/app/modules/login/domain/entities/type_alert.dart';

class MessageAlert {

  String title;
  String msg;
  TypeAlert type;

  MessageAlert.create(this.title, this.msg, this.type);
}
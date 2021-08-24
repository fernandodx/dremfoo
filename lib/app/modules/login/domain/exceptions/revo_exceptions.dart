class RevoExceptions implements Exception {

  late StackTrace? stack;
  late Exception? error;
  late String msg;

  RevoExceptions.msgToUser({this.stack, this.error, required this.msg});

}
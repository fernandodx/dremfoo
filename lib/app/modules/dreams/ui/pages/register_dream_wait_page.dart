import 'package:dremfoo/app/modules/dreams/domain/stories/register_dream_with_focus_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterDreamWaitPage extends StatefulWidget {
  @override
  RegisterDreamWaitPageState createState() => RegisterDreamWaitPageState();
}
class RegisterDreamWaitPageState extends ModularState<RegisterDreamWaitPage, RegisterDreamWithFocusStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RegisterDreamWaitPage"),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
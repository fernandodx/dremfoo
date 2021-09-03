import 'package:dremfoo/app/modules/dreams/domain/stories/dreams_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class DreamsPage extends StatefulWidget {
  final String title;
  const DreamsPage({Key? key, this.title = 'DreamsPage'}) : super(key: key);
  @override
  DreamsPageState createState() => DreamsPageState();
}
class DreamsPageState extends ModularState<DreamsPage, DreamsStore> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
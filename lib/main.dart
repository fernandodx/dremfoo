import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/ui/register_dreams_page.dart';
import 'package:dremfoo/ui/home_page.dart';
import 'package:dremfoo/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'eventbus/main_event_bus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider<MainEventBus>(
          builder: (context) => MainEventBus(),
          dispose: (context, mainEventBus) => mainEventBus.dispose(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dremfo - Construindo Sonhos',
        theme: ThemeData(
          fontFamily: "Alata",
          primaryColor: AppColors.colorPrimary,
          accentColor: AppColors.colorAcent,
          primaryColorDark: AppColors.colorPrimaryDark,
          canvasColor: Colors.transparent,
        ),
      home: LoginPage(),
//      home: HomePage(),
//      home: CadastroSonhoPage(),
      ),
    );
  }
}

//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Somnia - Construindo sonhos"),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'Somnia : Construindo Sonhos',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ),
//    );
//  }
//}

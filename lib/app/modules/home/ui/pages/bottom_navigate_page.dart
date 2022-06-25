import 'package:dremfoo/app/modules/core/config/app_purchase.dart';
import 'package:dremfoo/app/modules/home/domain/stories/bottom_navigate_store.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/remoteconfig_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigatePage extends StatefulWidget {
  final String title;

  const BottomNavigatePage({Key? key, this.title = 'Revo  - Metas com foco'}) : super(key: key);

  @override
  BottomNavigatePageState createState() => BottomNavigatePageState();
}

class BottomNavigatePageState extends ModularState<BottomNavigatePage, BottomNavigateStore> {

  @override
  void initState() {
    super.initState();

    // Modular.to.navigate('/home/dashboard');

    // Modular.to.navigate('/home/dream');
    // Navigator.pushNamed(context, "/dream");
  }

  @override
  Widget build(BuildContext context) {

    // AppBar myAppBar = AppbarRevoWidget(title: "Revo - Metas com foco").appBar;

    return Observer(
      builder: (context){
        return Scaffold(
          // appBar: store.isAppBarVisible ? myAppBar : null,
          // body: _widgetOptions.elementAt(_selectedIndex),
          body: RouterOutlet(),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: Theme.of(context).backgroundColor),
            child: BottomNavigationBar(
              items: getListItemBottom(),
              currentIndex: store.selectedIndex,
              onTap: (index) {
                store.navigatePageBottomNavigate(index);
              },
            ),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> getListItemBottom() {

    List<BottomNavigationBarItem> list =[];

    list.add(BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.home),
      label: Translate.i().get.label_home,
    ));

    list.add(BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.cloud),
      label: Translate.i().get.label_dreams,
    ));

    list.add(BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.trophy),
        label: Translate.i().get.label_rank));

    list.add(BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.calendarCheck),
        label: Translate.i().get.label_daily_planning));

    return list;

  }


}

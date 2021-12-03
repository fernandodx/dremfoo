import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/appbar_revo_widget.dart';
import 'package:dremfoo/app/modules/home/domain/stories/bottom_navigate_store.dart';
import 'package:dremfoo/app/modules/home/ui/pages/home_page.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Modular.to.navigate('/home/dashboard');
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
          backgroundColor: AppColors.colorBackground,
          // body: _widgetOptions.elementAt(_selectedIndex),
          body: RouterOutlet(),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: AppColors.colorDark),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.home),
                  label: Translate.i().get.label_home,
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.cloud),
                  label: Translate.i().get.label_dreams,
                ),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.chartLine),
                    label: Translate.i().get.label_statistics),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
                    label: Translate.i().get.label_challenges),
                BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.trophy),
                    label: Translate.i().get.label_challenges),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.colorAcent,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                print(index);
                // setState(() {
                //   _selectedIndex = index;
                // });
                if (index == 0) {
                  store.showHideAppBar(true);
                  Modular.to.navigate('/home/dashboard');
                } else if (index == 1) {
                  store.showHideAppBar(false);
                  Modular.to.navigate('/home/dream');
                } else if (index == 2) {
                  Modular.to.navigate('/home/chart');
                } else if (index == 3) {
                  store.showHideAppBar(false);
                  Modular.to.navigate('/home/rank');
                } else if (index == 4) {
                  store.showHideAppBar(false);
                  Modular.to.navigate('/home/challenge');
                }
              },
            ),
          ),
        );
      },
    );
  }
}

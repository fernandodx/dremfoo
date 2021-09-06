import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/home/domain/stories/bottom_navigate_store.dart';
import 'package:dremfoo/app/modules/home/ui/pages/home_page.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

    // Modular.to.navigate('/home/dashboard');
    Modular.to.navigate('/home/dream');

  }

  @override
  Widget build(BuildContext context) {
    TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.colorAcent);
    var _widgetOptions = <Widget>[
      HomePage(),
      Text(
        'Index 1: Business',
        style: optionStyle,
      ),
      Text(
        'Index 2: School',
        style: optionStyle,
      ),
      Text(
        'Index 3: School',
        style: optionStyle,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: TextUtil.textAppbar(widget.title),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 32),
              child: InkWell(
                onTap: (){
                  print("menu");
                },
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(Utils.getPathAssetsImg("icon_user_not_found.png"),
                ),
                ),
              ),
          ),
        ],
      ),
      backgroundColor: AppColors.colorBackground,
      // body: _widgetOptions.elementAt(_selectedIndex),
      body: RouterOutlet(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: AppColors.colorDark),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Sonhos"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Gráficos"),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: "Desafios"),
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
              Modular.to.navigate('/home/dashboard');
            } else if (index == 1) {
              Modular.to.navigate('/home/dream');
            } else if (index == 2) {
              Modular.to.navigate('/home/chart');
            } else if (index == 3) {
              Modular.to.navigate('/home/challenge');
            }
          },
        ),
      ),
    );
  }
}

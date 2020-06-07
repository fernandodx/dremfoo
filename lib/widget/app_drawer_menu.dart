import 'dart:ui';

import 'package:dremfoo/eventbus/main_event_bus.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawerMenu extends StatelessWidget {

  String urlImgBackgound;

  AppDrawerMenu({this.urlImgBackgound = "https://i0.wp.com/errejotanoticias.com.br/wp-content/uploads/2019/12/Divulgação-Foto-da-exposição-Canoa-Havaiana.jpeg?fit=880%2C660&ssl=1"});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: AppColors.backgroundDrawerDecoration(),
        child: ListView(
          children: <Widget>[
            StreamBuilder<FirebaseUser>(
                stream: MainEventBus().get(context).streamUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _userAccountHeader(snapshot.data);
                  }

                  return FutureBuilder(
                    future: FirebaseAuth.instance.currentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _userAccountHeader(snapshot.data);
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                }),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: Text(
                "Editar",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Alterar informações da conta",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => print("EDITAR"),
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: Text(
                "Editar",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Alterar informações da conta",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => print("EDITAR"),
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: Text(
                "Editar",
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Alterar informações da conta",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => print("EDITAR"),
            ),
          ],
        ),
      ),
    );
  }


  _userAccountHeader(FirebaseUser user) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(urlImgBackgound,
              ))),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 4,
          sigmaX: 4,
        ),
        child: UserAccountsDrawerHeader(
          decoration: BoxDecoration(),
          accountName: Text(user.displayName ?? ""),
          accountEmail: Text(user.email),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl ??
                "https://cdn3.iconfinder.com/data/icons/avatars-15/64/_Bearded_Man-17-512.png"),
          ),
        ),
      ),
    );
  }
}

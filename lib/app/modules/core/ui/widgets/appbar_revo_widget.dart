import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/circle_avatar_user_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/login_module.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppbarRevoWidget {
  final UserRevo? userRevo;
  final String title;
  final String? urlImageUser;
  final BuildContext context;

  AppbarRevoWidget(
      {required this.context, required this.userRevo, required this.title, this.urlImageUser});

  get appBar {
    return AppBar(
      title: TextUtil.textAppbar(title),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 32),
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorBackground,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 8),
                                        child: FaIcon(
                                          FontAwesomeIcons.times,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextUtil.textTitulo("Configurações"),
                                  )
                                ],
                              ),
                              SpaceWidget(),
                              Divider(thickness: 2, height: 8,),
                              ListTile(
                                leading: FaIcon(FontAwesomeIcons.userEdit, size: 20,),
                                title: TextUtil.textSubTitle("Alterar perfil", fontSize: 16),
                                enableFeedback: true,
                                onTap: () {
                                  print("EDITAR PERFIL");
                                  //User Logado... Deve ser preenchido
                                  UserRevo currentuser = Modular.get<UserRevo>();
                                  if(currentuser.name == null){
                                    currentuser.name = "veio null";
                                  }
                                  Modular.to.pushNamed("/editUser", arguments: currentuser);
                                },
                              ),
                              SwitchListTile(
                                  secondary: FaIcon(FontAwesomeIcons.adjust, size: 20,),
                                  title: TextUtil.textSubTitle("Tema escuro", fontSize: 16),
                                  value: true,
                                  onChanged: (isChange) {
                                    print(isChange);
                                  }
                              ),
                              Divider(thickness: 2, height: 8,),
                              ListTile(
                                leading: FaIcon(FontAwesomeIcons.signOutAlt, size: 20,),
                                title: TextUtil.textSubTitle("Sair", fontSize: 16),
                                enableFeedback: true,
                                onTap: () {
                                  print("SAIR");
                                },
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            borderRadius: BorderRadius.all(Radius.circular(50)),
            child: CircleAvatarUserRevoWidget(
              urlImage: userRevo?.urlPicture,
            ),
          ),
        ),
      ],
    );
  }
}

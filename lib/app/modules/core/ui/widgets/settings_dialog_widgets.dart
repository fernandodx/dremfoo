import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/stories/register_user_store.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'circle_avatar_user_revo_widget.dart';

class SettingsDialogWidgets extends StatelessWidget {

  late RegisterUserStore _registerUserStore;
  late UserRevo _currentuser;

  SettingsDialogWidgets(){
    _registerUserStore = Modular.get<RegisterUserStore>();
    _currentuser = Modular.get<UserRevo>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
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
                    child: TextUtil.textTitulo(Translate.i().get.label_settings),
                  )
                ],
              ),
              InkWell(
                child: Observer(
                  builder: (_) {
                    if (_registerUserStore.containerImage == null) {
                      return Container(
                        width: 120,
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        child: CircleAvatarUserRevoWidget(
                          radiusSize: 50,
                          size: 90,
                          isShowEdit: true,
                          urlImage: _currentuser.urlPicture,
                        ),
                      );
                    }
                    return _registerUserStore.containerImage!;
                  },
                ),
                onTap: () => _registerUserStore.updatePictureUser(),
              ),
              Divider(
                thickness: 2,
                height: 8,
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.userEdit,
                  size: 20,
                ),
                title: TextUtil.textSubTitle(Translate.i().get.label_change_profile, fontSize: 16),
                enableFeedback: true,
                onTap: () {
                  Modular.to.pushNamed("/editUser", arguments: _currentuser);
                },
              ),
              Observer(
                builder: (context) {
                  return SwitchListTile(
                      secondary: FaIcon(
                        FontAwesomeIcons.adjust,
                        size: 20,
                      ),
                      title: TextUtil.textSubTitle(Translate.i().get.label_dark_theme, fontSize: 16),
                      value: _registerUserStore.isThemeDark,
                      onChanged: (isThemeDark) {
                        _registerUserStore.changeThemeDarkUser(isThemeDark, context);
                      });
                },
              ),
              Divider(
                thickness: 2,
                height: 8,
              ),
              ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  size: 20,
                ),
                title: TextUtil.textSubTitle(Translate.i().get.label_exit, fontSize: 16),
                enableFeedback: true,
                onTap: () {
                  _registerUserStore.logOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}

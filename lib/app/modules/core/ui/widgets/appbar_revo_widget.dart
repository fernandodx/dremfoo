import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/circle_avatar_user_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/settings_dialog_widgets.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/stories/register_user_store.dart';
import 'package:dremfoo/app/modules/login/domain/usecases/login_usecase.dart';
import 'package:dremfoo/app/modules/login/login_module.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    RegisterUserStore _registerUserStore = Modular.get<RegisterUserStore>();

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
                    return SettingsDialogWidgets();
                  });
            },
            borderRadius: BorderRadius.all(Radius.circular(50)),
            child: Observer(
              builder: (context) => CircleAvatarUserRevoWidget(
                urlImage: userRevo?.urlPicture,
                image: _registerUserStore.imageUser != null ? _registerUserStore.imageUser : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

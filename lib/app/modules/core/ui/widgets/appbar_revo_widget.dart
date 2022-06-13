import 'package:dremfoo/app/modules/core/ui/widgets/circle_avatar_user_revo_widget.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/settings_dialog_widgets.dart';
import 'package:dremfoo/app/modules/home/domain/stories/list_alert_report_goal_dream_store.dart';
import 'package:dremfoo/app/modules/login/domain/entities/user_revo.dart';
import 'package:dremfoo/app/modules/login/domain/stories/register_user_store.dart';
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
    ListAlertReportGoalDreamStore _listReportGoalDream = Modular.get<ListAlertReportGoalDreamStore>();

    return AppBar(
      title: TextUtil.textAppbar(title),
      actions: [
        Container(
          width: 40,
          margin: EdgeInsets.only(right: 20),
          alignment: Alignment.center,
          child: InkWell(
            child: Stack(
              children: [
                FaIcon(
                  FontAwesomeIcons.solidBell,
                  size: 22,
                ),
                Observer(
                    builder: (context) => Visibility(
                        visible: _registerUserStore.isNewNotificationReportDream,
                        child: FaIcon(
                          Icons.circle,
                          size: 12,
                          color: Theme.of(context).canvasColor,
                        ))),
              ],
            ),
            onTap: () => _listReportGoalDream.open(context),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20),
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

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/Translate.dart';
import '../../../../utils/text_util.dart';

class CardFeatureOnlyUsersSubscriberWidget extends StatelessWidget {
  const CardFeatureOnlyUsersSubscriberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, bottom: 8),
      child:  Card(
        elevation: 4,
        child: Container(
          child: Column(
            children: [
              ListTile(
                title: TextUtil.textSubTitle(
                    Translate.i().get.msg_daily_planning_subscriber_only),
                leading: FaIcon(
                  FontAwesomeIcons.award,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

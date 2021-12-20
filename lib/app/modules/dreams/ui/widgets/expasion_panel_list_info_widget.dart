import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:flutter/material.dart';

class ExpasionPanelListInfoWidget extends StatelessWidget {

  final Function(int, bool)? expansionCallback;
  final String subtitle;
  final bool isExpanded;
  final Function()? onTap;

  ExpasionPanelListInfoWidget({
        this.expansionCallback,
        this.onTap,
        required this.subtitle,
        required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: expansionCallback,
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: TextUtil.textDefault(Translate.i().get.label_information, fontSize: 16),
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).canvasColor,
              ),
              onTap: onTap,
            );
          },
          body: Container(
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 16),
            child: TextUtil.textSubTitle(subtitle, align: TextAlign.justify),
          ),
          isExpanded: isExpanded,
        )
      ],
    );
  }
}
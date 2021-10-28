import 'package:dremfoo/app/modules/core/domain/utils/utils.dart';
import 'package:dremfoo/app/modules/core/ui/widgets/space_widget.dart';
import 'package:dremfoo/app/resources/app_colors.dart';
import 'package:dremfoo/app/utils/Translate.dart';
import 'package:dremfoo/app/utils/text_util.dart';
import 'package:dremfoo/app/widget/app_text_default.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContentStepInfoDreamWidget extends StatelessWidget {

  final TextEditingController? dreamTextEditController;
  final TextEditingController? dreamDescriptionTextEditController;
  final String? imageDreamBase64;
  final Function()? onTapOpenGallery;
  final Function()? onTapSearchOnInternet;

  ContentStepInfoDreamWidget({
    this.dreamTextEditController,
    this.dreamDescriptionTextEditController,
    this.imageDreamBase64,
    this.onTapOpenGallery,
    this.onTapSearchOnInternet});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        AppTextDefault(
          name: Translate.i().get.label_dream,
          controller: dreamTextEditController,
          icon: Icons.cloud,
          maxLength: 35,
        ),
       SpaceWidget(),
        AppTextDefault(
          name: Translate.i().get.label_description_dream,
          controller: dreamDescriptionTextEditController,
          icon: Icons.description,
          maxLength: 60,
        ),
       SpaceWidget(),
        TextUtil.textAccent(Translate.i().get.label_choose_image_dream),
       SpaceWidget(),
        Container(
          padding: EdgeInsets.all(8),
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: getImageDream(),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.colorDark,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))
                      ),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  child: FaIcon(FontAwesomeIcons.images, size: 15,),
                                ),
                                TextUtil.textSubTitle(
                                    Translate.i().get.label_search_gallery,
                                    align: TextAlign.center
                                ),
                              ],
                            ),
                            onTap: onTapOpenGallery,
                          ),
                          SpaceWidget(isSpaceRow: true,),
                          InkWell(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  // child:  Icon(Icons.wifi_tethering),
                                  child: FaIcon(FontAwesomeIcons.wifi, size: 15,),
                                ),
                                TextUtil.textSubTitle(
                                    Translate.i().get.label_search_internet,
                                    align: TextAlign.center
                                ),
                              ],
                            ),
                            onTap: onTapSearchOnInternet,
                          )
                        ],
                      ),
                    );
                  });
            },
          ),
        ),
      ],
    );
  }

  Widget getImageDream() {
    if (imageDreamBase64 != null && imageDreamBase64!.isNotEmpty) {
      return Utils.string64ToImage(imageDreamBase64!, fit: BoxFit.cover);
    } else {
      return Image.asset(
        Utils.getPathAssetsImg("icon_gallery_add.png"),
        width: 100,
        height: 100,
        scale: 5,
      );
    }
  }
}
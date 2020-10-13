import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dremfoo/model/response_api.dart';
import 'package:dremfoo/resources/app_colors.dart';
import 'package:dremfoo/utils/crashlytics_util.dart';
import 'package:dremfoo/utils/nav.dart';
import 'package:dremfoo/utils/text_util.dart';
import 'package:dremfoo/utils/utils.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_api.dart';

final _controller = StreamController<String>.broadcast();
final _controllerDonwload = StreamController<bool>.broadcast();
Stream<bool> get _streamDonwload => _controllerDonwload.stream;

class SearchPictureInternet extends StatelessWidget {
  Stream<String> get stream => _controller.stream;


  String namePicture;

  SearchPictureInternet(this.namePicture);

  @override
  Widget build(BuildContext context) {
    _controllerDonwload.add(false);
    return Scaffold(
      backgroundColor: AppColors.colorEggShell,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              title: TextUtil.textAppbar(
                  namePicture.isEmpty ? "Pesquise uma imagem" : namePicture),
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () =>
                        showSearch(context: context, delegate: DataSearch()), )
              ],
            ),
          ];
        },
        body: getGridViewForPicture(namePicture),
      ),
    );
  }
}

Widget getGridViewForPicture(String namePicture) {
  return Stack(
    children: [
      Container(
        child: FutureBuilder(
          future: searchPictureInternet(namePicture),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              ResponseApi<List<PixabayMedia>> responseApi = snapshot.data;
              if (responseApi.ok) {
                List<PixabayMedia> list = responseApi.result;

                return GridView.builder(
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          returnImageBase64(list, index, context);
                        },
                        child: Container(
                          color: AppColors.colorEggShell,
                          padding: EdgeInsets.all(3),
                          child: CachedNetworkImage(
                            imageUrl: list[index].getThumbnailLink(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    });
              } else {
                return Container(
                  color: AppColors.colorEggShell,
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        child: FlareActor(
                          Utils.getPathAssetsAnim("empty_not_found-idle.flr"),
                          shouldClip: true,
                          animation: "idle",
                        ),
                      ),
                      Center(
                        child: TextUtil.textTitulo(responseApi.msg),
                      ),
                      Center(
                        child: TextUtil.textSubTitle(
                            "Tente pesquisar por uma palavra específica"),
                      ),
                    ],
                  ),
                );
              }
            }

            return Container(
              color: AppColors.colorEggShell,
              child: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      ),
      StreamBuilder(
        stream: _streamDonwload,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Visibility(
              visible: snapshot.data,
              child: Container(
                color: Colors.black26,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
         return Container();
        },
      )
    ],
  );
}

void returnImageBase64(List<PixabayMedia> list, int index, BuildContext context) async {
  _controllerDonwload.add(true);
  String base64 = await donwloadImageConvertBase64(list, index);
  _controller.add(base64);
  _controllerDonwload.add(false);
  pop(context,null);
}

Future<String> donwloadImageConvertBase64(
    List<PixabayMedia> list, int index) async {
  BytesBuilder bytes =
      await getApiSearch().downloadMedia(list[index], Resolution.small);
  String base64Image = base64Encode(bytes.toBytes());
  return base64Image;
}

Future<ResponseApi<List<PixabayMedia>>> searchPictureInternet(
    String namePicture,
    {int pages = 80}) async {
  try {
    PixabayMediaProvider api = getApiSearch();

    PixabayResponse res = await api.requestImagesWithKeyword(
      keyword: namePicture,
      resultsPerPage: pages,
    );

    if (res != null && res.hits.isNotEmpty) {
      return ResponseApi.ok(result: res.hits);
    }

    return ResponseApi.error(msg: "Nenhuma imagem encontrada");
  } catch (error, stack) {
    CrashlyticsUtil.logErro(error, stack);
    return ResponseApi.error(msg: "Nenhuma imagem encontrada");
  }

}

PixabayMediaProvider getApiSearch() {
  PixabayMediaProvider api = PixabayMediaProvider(
      apiKey: "18605365-d9a67f319efe8778a789de0b3", language: "pt");
  return api;
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //Actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    if (query.isNotEmpty && query.length > 3) {
      return getGridViewForPicture(query);
    }

    return Container(
      color: AppColors.colorEggShell,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  String get searchFieldLabel => "Pesquisar";
}

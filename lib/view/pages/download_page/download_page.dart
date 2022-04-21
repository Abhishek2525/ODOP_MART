import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iotflixcinema/core/view_models/VideoDetailsViewModel.dart';
import 'package:iotflixcinema/core/view_models/download_view_model/download_view_model.dart';
import 'package:iotflixcinema/view/constant/app_colors.dart';
import 'package:iotflixcinema/view/pages/home/homepage.dart';
import 'package:iotflixcinema/view/router/app_router.dart';
import 'package:iotflixcinema/view/widgets/custom_drawer.dart';

import '../base_screen.dart';
import 'card/download_item_card.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends BaseScreen<DownloadPage> {
  int rebuild = 0;

  @override
  void initState() {
    super.initState();
  }

  String text = "default";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Expanded(
            child: Center(
              child: Text(
                "Download",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                AppRouter.navToExploreSearchPage();
              },
              child: ImageIcon(
                AssetImage(
                  'images/searchIcon.png',
                ),
                size: 18,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          child: Container(
            color: AppColors.deepRed,
            height: .5,
          ),
          preferredSize: Size.fromHeight(1.5),
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: 10.0,
          ),
          child: GetBuilder<DownloadViewModel>(
            builder: (c) {
              return Container(
                child: ListView(
                  children: [
                    for (int i = 0; i < c.downloadedList.length; i++)
                      DownloadedItemCard(
                        index: i,
                        imgPath: c.downloadedList[i]?.data?.thumbnail,
                        model: c.downloadedList[i]?.data,
                        onDelete: () {},
                        onTap: () async {
                          var model = c.downloadedList[i]?.data;
                          model.videoUrl =
                              c.downloadedList[i].task.downloadedPath;
                          print(model.toJson());
                          try {
                            VideoDetailsViewModel m = Get.find();
                            Get.delete<VideoDetailsViewModel>();
                            m = Get.put(VideoDetailsViewModel(model));
                            m.newInit(model);
                          } catch (e) {
                            VideoDetailsViewModel m =
                                Get.put(VideoDetailsViewModel(model));
                            m.newInit(model);
                          }

                          await AppRouter.navToVideoDetailsPage(
                              model,
                              HomePageFragment.favouriteNavId,
                              model.categoryId);

                        //  Get.delete<AppPlayerController>();
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
  }
}

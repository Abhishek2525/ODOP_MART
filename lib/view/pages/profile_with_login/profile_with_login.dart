import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/models/home_categories_model.dart';
import '../../../core/models/keep_watching_model.dart';
import '../../../core/view_models/VideoDetailsViewModel.dart';
import '../../../core/view_models/download_view_model/download_view_model.dart';
import '../../../core/view_models/fevorite_view_model.dart';
import '../../../core/view_models/history_view_model/history_view_model.dart';
import '../../../core/view_models/keep_watching_controller.dart';
import '../../../core/view_models/play_from_controller.dart';
import '../../../core/view_models/profile_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/shimmers/image_shimmer.dart';
import '../base_screen.dart';
import '../dashboard/view/vedio_card_view.dart';
import '../home/homepage.dart';

class ProfileWithLogIn extends StatefulWidget {
  final int nestedId;

  ProfileWithLogIn({this.nestedId});

  @override
  _ProfileWithLogInState createState() => _ProfileWithLogInState();
}

class _ProfileWithLogInState extends BaseScreen<ProfileWithLogIn>
    with AutomaticKeepAliveClientMixin {
  Function wp;
  Function hp;

  ProfileViewModel logoutController = Get.put(ProfileViewModel());
  FavoriteViewModel favoriteViewModel = Get.put(FavoriteViewModel());

  HistoryViewModel historyViewModel = Get.put(HistoryViewModel());

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
      ),
      body: GetBuilder<ProfileViewModel>(
        builder: (controller) {
          var userNameColor = ThemeController.currentThemeIsDark
              ? AppColors.white
              : AppColors.black;
          var backgroundCOlor = ThemeController.currentThemeIsDark
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).appBarTheme.backgroundColor;
          return SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: hp(30),
                    width: wp(100),
                    color: backgroundCOlor,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(wp(15)),
                              child: Container(
                                color: AppColors.white,
                                height: wp(30),
                                width: wp(30),
                                padding: EdgeInsets.all(2),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(wp(14)),
                                  child: FadeInImage(
                                    width: wp(30),
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage(
                                      ImageNames.thumbPlaceHolder,
                                    ),
                                    placeholderErrorBuilder:
                                        (context, object, stackTrae) {
                                      return getImageShimmer(
                                          height: wp(30), width: wp(30));
                                    },
                                    image: ExtendedNetworkImageProvider(
                                      '${AppUrls.imageBaseUrl}${controller?.profileModel?.data?.avatar}',
                                      cache: true,
                                      cacheRawData: true,
                                      imageCacheName:
                                          '${AppUrls.imageBaseUrl}${controller?.profileModel?.data?.avatar}',
                                    ),
                                    imageErrorBuilder:
                                        (context, object, stackTrae) {
                                      return Image.asset(
                                          "images/dark-mode.png"); //getImageShimmer(height: wp(30), width: wp(30));
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: hp(0),
                              bottom: wp(0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(wp(4)),
                                child: Container(
                                  height: wp(8),
                                  width: wp(8),
                                  color: AppColors.white,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      AppRouter.navToEditProfilePage(
                                          /*nestedId: widget?.nestedId,*/
                                          );
                                    },
                                    icon: Icon(
                                      Icons.create,
                                      color: AppColors.deepRed,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          controller?.profileModel?.data?.name ?? "",
                          style: TextStyle(
                            fontSize: 22,
                            color: userNameColor,
                          ),
                        ),
                        Text(
                          controller.profileModel?.data?.email ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.yellowColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: wp(100),
                    height: hp(.2),
                    color: AppColors.deepRed,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  _getFevouriteListWidget(),
                  _getKeepWatchingWidget(),
                  _getDownloadList(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void afterFirstLayout(BuildContext context) {}

  Widget _getFevouriteListWidget() {
    return VideoCardView(
      listModel: favoriteViewModel.allFavoriteModel?.value?.data,
      onMoreTap: () {
        AppRouter.navToMoreVideosPage(
          catName: 'Favourites',
          catImage: null,
          homeDataList: favoriteViewModel.allFavoriteModel?.value?.data,
        );
      },
      titleName: 'My Favorite',
    );
  }

  Widget getWatchListWidget() {
    List<HomeData> videoList = [];

    for (var data
        in historyViewModel?.historyDataModel?.value?.data?.data ?? []) {
      videoList.add(data.video);
    }

    return VideoCardView(
      listModel: videoList,
      onMoreTap: () {
        AppRouter.navToMoreVideosPage(
          catName: 'Favourites',
          catImage: null,
          homeDataList: videoList,
        );
      },
      titleName: 'Watch list',
    );
  }

  KeepWatchingController keepWatchingController =
      Get.put(KeepWatchingController());

  Widget _getKeepWatchingWidget() {
    return Obx(() {
      if (keepWatchingController.keepWatchingVideoList.isEmpty) {
        return Container();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 15, bottom: 5),
              child: Text(
                'Watch List',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.headline1.color,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: wp(29) * (13 / 10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: keepWatchingController.keepWatchingVideoList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  HomeData video =
                      keepWatchingController.keepWatchingVideoList[index];
                  KeepWatchingModel keepWatchingModel =
                      keepWatchingController.keepWatchingModelList[index];

                  /// calculate the percentage of played video
                  double playedParcentage = ((keepWatchingModel.totalDuration -
                              keepWatchingModel.playedTill) /
                          keepWatchingModel.totalDuration) *
                      100;
                  playedParcentage = 100 - playedParcentage;

                  return Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: GestureDetector(
                      onTap: () {
                        PlayFromController.playFrom =
                            keepWatchingModel.playedTill;

                        var videoDetailsController =
                            Get.put(VideoDetailsViewModel(video));
                        videoDetailsController.initialData.value = video;
                        videoDetailsController.getVideoDetailsMethod(
                            video.id.toString(), video.categoryId);
                        AppRouter.navToVideoDetailsPage(
                          video,
                          HomePageFragment.dashboardNavId,
                          video.categoryId,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            ExtendedImage.network(
                              AppUrls.imageBaseUrl + video.thumbnail,
                              borderRadius: BorderRadius.circular(8),
                              width: wp(29),
                              height: double.infinity,
                              fit: BoxFit.cover,
                              cache: true,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                height: 4,
                                color: Colors.deepOrange,
                                width: (playedParcentage / 100) * wp(30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }

  // DownloadViewModel downloadViewModel = Get.put(DownloadViewModel());

  Widget _getDownloadList() {
    return GetBuilder<DownloadViewModel>(
      builder: (c) {
        if (c.downloadedList.length == 0) return Container();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 15, bottom: 5),
              child: Text(
                'Downloaded List',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).textTheme.headline1.color,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: wp(29) * (13 / 10),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: c.downloadedList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  HomeData video = c.downloadedList[index].data;

                  return Card(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: GestureDetector(
                      onTap: () {
                        var videoDetailsController =
                            Get.put(VideoDetailsViewModel(video));
                        videoDetailsController.initialData.value = video;
                        videoDetailsController.getVideoDetailsMethod(
                            video.id.toString(), video.categoryId);
                        AppRouter.navToVideoDetailsPage(
                          video,
                          HomePageFragment.dashboardNavId,
                          video.categoryId,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            ExtendedImage.network(
                              AppUrls.imageBaseUrl + video.thumbnail,
                              borderRadius: BorderRadius.circular(8),
                              width: wp(29),
                              height: double.infinity,
                              fit: BoxFit.cover,
                              cache: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/VideoDetailsViewModel.dart';
import '../../../core/view_models/actor_view_model.dart';
import '../../../core/view_models/fevorite_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../../core/view_models/video_player_controllers/app_player_controller.dart';
import '../../../core/view_models/video_view_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/shimmers/grid_shimmer.dart';
import '../action_category/action_category_img_card.dart';
import '../action_category/action_category_sponsored_card.dart';
import '../home/homepage.dart';
import '../video_details/vedio_player/youtube_player.dart';

class ActorsAllMoviesPage extends StatefulWidget {
  final String catName;
  final int nestedId;
  final String catImage;
  final bool fromVideoDetailsPage;

  ActorsAllMoviesPage(
      {this.nestedId, this.catName, this.catImage, this.fromVideoDetailsPage});

  @override
  _ActorsAllMoviesPageState createState() => _ActorsAllMoviesPageState();
}

class _ActorsAllMoviesPageState extends State<ActorsAllMoviesPage> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;

    ActorViewModel _actorViewModel = Get.put(ActorViewModel());

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: hp(30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7),
                            BlendMode.srcOver,
                          ),
                          image: ExtendedNetworkImageProvider(
                            widget?.catImage ?? 'https://picsum.photos/60',
                            cache: true,
                            cacheRawData: true,
                            imageCacheName: widget?.catImage ??
                                'https:/picsum.photos/60'
                                    'https://picsum.photos/60',
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 2),
                            color: Colors.black38,
                          )
                        ]),
                    child: Center(
                      child: Text(
                        widget?.catName ?? "Category name",
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppRouter.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 40),
                      child: ImageIcon(
                        AssetImage('images/backIcon.png'),
                        size: 20,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        AppRouter.navToExploreSearchPage();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, top: 42),
                        child: ImageIcon(
                          AssetImage('images/searchIcon.png'),
                          size: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Obx(() {
                bool isDarkTheme = ThemeController.currentThemeIsDark;
                String noDataImagePath = ImageNames.noDataForDarkTheme;
                if (isDarkTheme == false) {
                  noDataImagePath = ImageNames.noDataForLightTheme;
                }

                if (_actorViewModel.actorMovieModelLoading.value == true) {
                  return getGridShimmer(wp, hp);
                } else if (_actorViewModel
                        ?.actorsMoviesModel?.value?.data?.data1?.length ==
                    0) {
                  return Container(
                    height: wp(50),
                    width: wp(50),
                    child: Center(
                      child: Image.asset(noDataImagePath),
                    ),
                  );
                } else {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 4 / 5,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _actorViewModel?.actorsMoviesModel?.value
                                    ?.data?.data1?.length ??
                                0,
                            itemBuilder: (BuildContext context, int index) =>
                                ActionCategoryImgCard(
                              imgPath: _actorViewModel?.actorsMoviesModel?.value
                                          ?.data?.data1[index]?.thumbnail !=
                                      null
                                  ? AppUrls.imageBaseUrl +
                                      _actorViewModel?.actorsMoviesModel?.value
                                          ?.data?.data1[index]?.thumbnail
                                  : "https://picsum.photos/60",
                              onTap: () {
                                if (widget.fromVideoDetailsPage == null) {
                                  AppRouter.navToVideoDetailsPage(
                                    _actorViewModel?.actorsMoviesModel?.value
                                        ?.data?.data1[index],
                                    HomePageFragment.exploreNavId,
                                    _actorViewModel?.actorsMoviesModel?.value
                                        ?.data?.data1[index].categoryId,
                                  );
                                  //  AppRouter.navToVideoDetailsPage();
                                } else {
                                  /// user navigate here from video details page so handle on click for this scenario
                                  VideoDetailsViewModel videoDetailsController =
                                      Get.find();
                                  videoDetailsController.refreshData(
                                      _actorViewModel?.actorsMoviesModel?.value
                                          ?.data?.data1[index]);

                                  AppRouter.navToVideoDetailsPage(
                                    _actorViewModel?.actorsMoviesModel?.value
                                        ?.data?.data1[index],
                                    HomePageFragment.exploreNavId,
                                    _actorViewModel?.actorsMoviesModel?.value
                                        ?.data?.data1[index].categoryId,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ActionCategorySponsoredCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleOnTap(var videoDetailsController, int index) async {
    videoDetailsController.refreshData(
      videoDetailsController?.categoryMaylikeModel?.data[index],
    );

    VideoViewViewModel videoVIewController = Get.put(VideoViewViewModel());
    videoVIewController.model.value = null;
    videoVIewController.model.value =
        videoDetailsController?.categoryMaylikeModel?.data[index];

    String strUrl =
        videoDetailsController?.categoryMaylikeModel?.data[index]?.videoUrl;
    String videoId = videoDetailsController
        ?.categoryMaylikeModel?.data[index]?.id
        ?.toString();
    String videoName =
        videoDetailsController?.categoryMaylikeModel?.data[index]?.title;

    /// call is favorite method to check the video is in fav list or not
    FavoriteViewModel favViewModel = Get.put(FavoriteViewModel());
    favViewModel.setFavorite(int.parse(videoId));

    if (!strUrl.contains('youtube') && !strUrl.contains('vimeo')) {
      AppPlayerController appPlayerController = Get.put(AppPlayerController());

      /// save last played video info
      await appPlayerController?.saveLastPlayedVideoInfo();

      /// play new video
      appPlayerController?.initBetterPlayerController(
          strUrl, videoId, videoName);
    } else {
      YoutubePlayerCustomCntroller youtubePlayerCustomController =
          Get.put(YoutubePlayerCustomCntroller());

      /// save last played video info
      await youtubePlayerCustomController?.saveLastPlayedVideoInfo();

      /// update youtube player video source with new video
      youtubePlayerCustomController.playMethod(strUrl, videoId, videoName);

      ///call video view count api
      videoVIewController.historyAddMethod(
        videoDetailsController?.categoryMaylikeModel?.data[index]?.id
            .toString(),
      );
    }
  }
}

import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/models/home_categories_model.dart';
import '../../../core/models/keep_watching_model.dart';
import '../../../core/view_models/VideoDetailsViewModel.dart';
import '../../../core/view_models/home_banner_view_model.dart';
import '../../../core/view_models/home_categories_view_model.dart';
import '../../../core/view_models/keep_watching_controller.dart';
import '../../../core/view_models/play_from_controller.dart';
import '../../../core/view_models/profile_view_model.dart';
import '../../../core/view_models/sponsor_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/shimmers/image_shimmer.dart';
import '../base_screen.dart';
import '../home/homepage.dart';
import 'cards/random_movie_card.dart';
import 'cards/sponsored_movie_card.dart';
import 'view/vedio_card_view.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends BaseScreen<Dashboard>
    with AutomaticKeepAliveClientMixin {
  Function wp;
  Function hp;

  final PageController controller =
      PageController(viewportFraction: 0.9, initialPage: 0);

  int _currentPage = 0;
  bool _needScroll = true;

  Timer timer;

  void _scrollToEnd() async {
    print("${controller.position.maxScrollExtent}");
    if (_needScroll) {
      _needScroll = false;
      controller.animateTo(
        controller.position.maxScrollExtent / 2.0,
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    }
  }

  bool pageSnapping = false;

  ProfileViewModel profileController = Get.put(ProfileViewModel());

  KeepWatchingController keepWatchingController =
      Get.put(KeepWatchingController());

  void chkLoggedIn() {
    profileController.getUserProfileMethod();
  }

  @override
  void initState() {
    super.initState();

    chkLoggedIn();

    timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      controller?.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    controller.addListener(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                AppRouter.navToExploreSearchPage();
              },
              child: ImageIcon(
                AssetImage('images/searchIcon.png'),
                size: 18,
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: GetBuilder<HomeCategoriesViewModel>(
        builder: (homeController) {
          if ((homeController?.homeCategoriesModel?.data?.dataMapKeys?.length ??
                  0) ==
              0) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/app_image/offline.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No Data Fount From Server",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  InkWell(
                    onTap: () {
                      AppRouter.navToDownloadPage();
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Text("Go To Downloads"),
                    ),
                  )
                ],
              ),
            );
          }
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),

                /// The top Banner slider widget
                SizedBox(
                  height: wp(90) * (5 / 11),
                  child: Center(
                    child: GetBuilder<HomeBannerViewModel>(
                      builder: (cntrl) => PageView.builder(
                        controller: controller,
                        itemCount: cntrl?.homeBannerModel?.data?.length ?? 0,
                        pageSnapping: true,
                        itemBuilder: (context, index) => RandomMovieCard(
                          imgPath: AppUrls.imageBaseUrl +
                                  cntrl?.homeBannerModel?.data[index]?.img ??
                              "",
                          contentUrl:
                              cntrl?.homeBannerModel?.data[index]?.url ?? '',
                          contentType:
                              cntrl?.homeBannerModel?.data[index]?.bannerType ??
                                  'none',
                        ),
                        onPageChanged: (int index) {},
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),

                /// Top banner page indicator widget
                Center(
                  child: Container(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 6,
                      effect: SlideEffect(
                        spacing: 4.0,
                        dotWidth: 20.0,
                        radius: 0,
                        dotHeight: 2.0,
                        dotColor: Colors.grey,
                        activeDotColor: AppColors.shadowRed,
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                ),

                /// keep watching video list widget
                _getKeepWatchingWidget(),
                SizedBox(
                  height: 5,
                ),

                GetBuilder<HomeCategoriesViewModel>(builder: (controller) {
                  int spPos = 0;
                  if ((controller?.homeCategoriesModel?.data?.dataMapKeys
                              ?.length ??
                          0) ==
                      0) {
                    return Container();
                  }

                  return Column(
                    children: [
                      for (int i = 0;
                          i <
                              (controller?.homeCategoriesModel?.data
                                      ?.dataMapKeys?.length ??
                                  0);
                          i++)
                        Column(
                          children: [
                            GetBuilder<HomeCategoriesViewModel>(
                              builder: (c) => VideoCardView(
                                titleName: GetUtils.capitalize(controller
                                    ?.homeCategoriesModel?.data?.dataMapKeys[i]
                                    .replaceAll("_", " ")),
                                listModel: c
                                    ?.homeCategoriesModel
                                    ?.data
                                    ?.dataMap[controller?.homeCategoriesModel
                                        ?.data?.dataMapKeys[i]]
                                    .map((e) => e?.returnHomeData())
                                    ?.toList(),
                                onMoreTap: () {
                                  AppRouter.navToMoreVideosPage(
                                    catName: GetUtils.capitalize(controller
                                        ?.homeCategoriesModel
                                        ?.data
                                        ?.dataMapKeys[i]
                                        .replaceAll("_", " ")),
                                    catImage: c
                                                ?.homeCategoriesModel
                                                ?.data
                                                ?.dataMap[controller
                                                    ?.homeCategoriesModel
                                                    ?.data
                                                    ?.dataMapKeys[i]]
                                                .map((e) => e?.returnHomeData())
                                                ?.toList()
                                                ?.first
                                                ?.thumbnail !=
                                            null
                                        ? AppUrls.imageBaseUrl +
                                            c
                                                ?.homeCategoriesModel
                                                ?.data
                                                ?.dataMap[controller
                                                    ?.homeCategoriesModel
                                                    ?.data
                                                    ?.dataMapKeys[i]]
                                                .map((e) => e?.returnHomeData())
                                                ?.toList()
                                                ?.first
                                                ?.thumbnail
                                        : "https://picsum.photos/200",
                                    homeDataList: c
                                        ?.homeCategoriesModel
                                        ?.data
                                        ?.dataMap[controller
                                            ?.homeCategoriesModel
                                            ?.data
                                            ?.dataMapKeys[i]]
                                        .map((e) => e?.returnHomeData())
                                        ?.toList(),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                        // if (i % 3 == 0)
                              // Container(
                              //   height: wp(90) * (5 / 11),
                              //   child: GetBuilder<SponsorViewModel>(
                              //     builder: (cntrlr) => (cntrlr
                              //                     ?.homeViewSponsorList
                              //                     ?.length ??
                              //                 0) ==
                              //             0
                              //         ? Container()
                              //         : Visibility(
                              //             visible: (cntrlr?.homeViewSponsorList
                              //                         ?.length ??
                              //                     0) >
                              //                 0,
                              //             // child: Container(
                              //             //   height: wp(90) * (5 / 11),
                              //             //   padding: const EdgeInsets.only(
                              //             //       left: 3, right: 3),
                              //             //   child: SponsoredMovieCard(
                              //             //     model: cntrlr.homeViewSponsorList[
                              //             //         (spPos++ %
                              //             //             cntrlr.homeViewSponsorList
                              //             //                 .length)],
                              //             //   ),
                              //             // ),
                              //           ),
                              //   ),
                              // ),
                          ],
                        ),
                    ],
                  );
                })
              ],
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

  /// this method returns a WidgetList containing keep watching video items
  ///
  /// (if user stop watching a video after playing some time, then app trace
  /// that video and marked as user may interested to watch this video latter,
  /// and this is the method returns those uncompleted movies WidgetList)
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
                'Keep Watching',
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
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
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            FadeInImage(
                              width: wp(29),
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: AssetImage(
                                ImageNames.thumbPlaceHolder,
                              ),
                              placeholderErrorBuilder:
                                  (context, object, stackTrae) {
                                return getImageShimmer(
                                    width: wp(29), height: double.infinity);
                              },
                              image: ExtendedNetworkImageProvider(
                                '${AppUrls.imageBaseUrl + video.thumbnail}',
                                cache: true,
                                cacheRawData: true,
                                imageCacheName:
                                    '${AppUrls.imageBaseUrl + video.thumbnail}',
                              ),
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
}

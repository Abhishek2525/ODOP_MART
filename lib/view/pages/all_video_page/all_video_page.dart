import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/all_videos_view_model.dart';
import '../../../core/view_models/sponsor_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../custom/grid_view/9_child_grid_view/nine_child_delegate.dart';
import '../../custom/grid_view/9_child_grid_view/nine_child_view_delegate.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/shimmers/grid_shimmer.dart';
import '../base_screen.dart';
import '../dashboard/cards/sponsored_movie_card.dart';
import '../home/homepage.dart';
import 'cards/all_video_img_card.dart';
import 'filter_bottom_sheet/filter_bottom_sheet.dart';

/// AllVideoPage
///
/// Contains all video grid
class AllVideoPage extends StatefulWidget {
  @override
  _AllVideoPageState createState() => _AllVideoPageState();
}

class _AllVideoPageState extends BaseScreen<AllVideoPage> {
  AllVideosViewModel allVideosViewModel = Get.put(AllVideosViewModel());
  int spPos = 0;

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: AppColors.deepRed,
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(0.0)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                AppRouter.navToExploreSearchPage(
                    nestedId: HomePageFragment.liveNavId);
              },
              child: ImageIcon(
                AssetImage('images/searchIcon.png'),
                size: 18,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await BottomSheetFilter.bottomSheetPro(context);
            },
            child: Container(
              height: 25,
              width: 25,
              margin: const EdgeInsets.only(right: 20.0, top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.shadowRed,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Center(
                child: ImageIcon(
                  AssetImage(
                    'images/liveFilterIcon.png',
                  ),
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Obx(() {
              if (allVideosViewModel.allVideoLoading.value == true ||
                  allVideosViewModel.allVideosModel.value == null) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: getGridShimmer(wp, hp, itemCount: 3),
                );
              } else {
                if (allVideosViewModel.allVideosModel.value.data.length == 0) {
                  bool isDarkTheme = ThemeController.currentThemeIsDark;
                  String noDataImagePath = ImageNames.noDataForDarkTheme;
                  if (isDarkTheme == false) {
                    noDataImagePath = ImageNames.noDataForLightTheme;
                  }

                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(top: hp(20)),
                      height: wp(50),
                      width: wp(50),
                      child: Image.asset(noDataImagePath),
                    ),
                  );
                }
                return GridView.custom(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: NineChildGridViewDelegate(
                    3 ,
                    secondCrossAxisCount: 1,
                    secondChildParIndex: 10,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                    firstChildHeight: wp(33) + 15,
                    secondChildHeight: wp(90) * (5 / 11),
                  ),
                  childrenDelegate: NineChildDelegate(
                    secondChildParIndex: 5,
                    children: [
                      ...Iterable.generate(
                        allVideosViewModel
                                ?.allVideosModel?.value?.data?.length ??
                            0,
                        (i) {
                          // if ((i + 1) % 10 == 0 && i != 0) {
                          //   return Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 0),
                          //     child: Container(
                          //       height: wp(90) * (5 / 11),
                          //       child: GetBuilder<SponsorViewModel>(
                          //           builder: (cntrlr) {
                          //         if (cntrlr.searchSponsorList.length == 0)
                          //           return Container();
                          //         return Container(
                          //           height: wp(90) * (5 / 11),
                          //           padding: const EdgeInsets.only(
                          //               left: 3, right: 3),
                          //           child: SponsoredMovieCard(
                          //             model: cntrlr?.searchSponsorList[
                          //                 (spPos++ %
                          //                     cntrlr.searchSponsorList.length)],
                          //           ),
                          //         );
                          //       }),
                          //     ),
                          //   );
                          // }
                          return AllVideoImgCard(
                            imgPath: AppUrls.imageBaseUrl +
                                allVideosViewModel
                                    ?.allVideosModel?.value?.data[i]?.thumbnail,
                            onTap: () {
                              AppRouter.navToVideoDetailsPage(
                                allVideosViewModel
                                    ?.allVideosModel?.value?.data[i],
                                HomePageFragment.liveNavId,
                                allVideosViewModel
                                    ?.allVideosModel?.value?.data[i].categoryId,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}

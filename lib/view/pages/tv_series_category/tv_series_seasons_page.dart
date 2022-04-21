import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../../core/view_models/tv_series_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/shimmers/tv_series_shimmer.dart';
import '../home/homepage.dart';
import 'individual_all_season_card.dart';
import 'tv_series_sponsored_card.dart';

class TvSeriesSeasonsPage extends StatefulWidget {
  TvSeriesSeasonsPage({this.id, this.nestedId});

  final String id;
  final int nestedId;

  @override
  _TvSeriesSeasonsPageState createState() => _TvSeriesSeasonsPageState();
}

class _TvSeriesSeasonsPageState extends State<TvSeriesSeasonsPage> {
  Function wp;
  Function hp;

  TvSeriesViewModel tvSeriesSeasonsController = Get.put(TvSeriesViewModel());

  @override
  void initState() {
    super.initState();
    tvSeriesSeasonsController.getTvSeriesSeasonsMethod(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Obx(() {
      if (tvSeriesSeasonsController.tvSeriesSeasonEpisodeLoading.value ==
          true) {
        return getTvSeriesShimmer(wp, hp);
      } else {
        return SingleChildScrollView(
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
                              Colors.black.withOpacity(0.5), BlendMode.srcOver),
                          image: ExtendedNetworkImageProvider(
                            tvSeriesSeasonsController?.tvSeriesSeasonsModel
                                        ?.value?.data?.img ==
                                    null
                                ? 'https://picsum.photos/100'
                                : AppUrls.imageBaseUrl +
                                    tvSeriesSeasonsController
                                        ?.tvSeriesSeasonsModel
                                        ?.value
                                        ?.data
                                        ?.img,
                            cache: true,
                            cacheRawData: true,
                            imageCacheName: tvSeriesSeasonsController
                                        ?.tvSeriesSeasonsModel
                                        ?.value
                                        ?.data
                                        ?.img ==
                                    null
                                ? 'https://picsum.photos/100'
                                : AppUrls.imageBaseUrl +
                                    tvSeriesSeasonsController
                                        ?.tvSeriesSeasonsModel
                                        ?.value
                                        ?.data
                                        ?.img,
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 2),
                              color: Colors.black38)
                        ]),
                    child: Center(
                      child: Text(
                        tvSeriesSeasonsController
                                ?.tvSeriesSeasonsModel?.value?.data?.name ??
                            " ",
                        style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'poppins_bold',
                            // fontWeight: FontWeight.bold,
                            fontSize: 26),
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
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 42),
                      child: GestureDetector(
                        onTap: () {
                          AppRouter.navToExploreSearchPage();
                        },
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

              /// season list gridview
              Obx(() {
                if (tvSeriesSeasonsController
                            .tvSeriesSeasonEpisodeLoading.value ==
                        false &&
                    tvSeriesSeasonsController
                        .tvSeriesSeasonsModel.value.data.seasons.isEmpty) {
                  bool isDarkTheme = ThemeController.currentThemeIsDark;
                  String noDataImagePath = ImageNames.noDataForDarkTheme;
                  if (isDarkTheme == false) {
                    noDataImagePath = ImageNames.noDataForLightTheme;
                  }

                  return Container(
                    height: wp(50),
                    width: wp(50),
                    child: Center(
                      child: Image.asset(noDataImagePath),
                    ),
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      // physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 4 / 5,
                          mainAxisSpacing: 30),
                      itemCount: tvSeriesSeasonsController?.tvSeriesSeasonsModel
                              ?.value?.data?.seasons?.length ??
                          0,
                      itemBuilder: (BuildContext context, int index) =>
                          IndividualAllSeasonCard(
                        title: tvSeriesSeasonsController?.tvSeriesSeasonsModel
                                ?.value?.data?.seasons[index]?.season ??
                            " Season no",
                        img: tvSeriesSeasonsController?.tvSeriesSeasonsModel
                                    ?.value?.data?.seasons[index]?.img ==
                                null
                            ? 'https://picsum.photos/100'
                            : AppUrls.imageBaseUrl +
                                tvSeriesSeasonsController?.tvSeriesSeasonsModel
                                    ?.value?.data?.seasons[index]?.img,
                        onTap: () {
                          AppRouter.navToIndividualSeasonPage(
                              episodes: tvSeriesSeasonsController
                                  ?.tvSeriesSeasonsModel
                                  ?.value
                                  ?.data
                                  ?.seasons[index]
                                  ?.episodes,
                              seriesName: tvSeriesSeasonsController
                                      ?.tvSeriesSeasonsModel
                                      ?.value
                                      ?.data
                                      ?.name ??
                                  " Series name",
                              seasonTitle: tvSeriesSeasonsController
                                      ?.tvSeriesSeasonsModel
                                      ?.value
                                      ?.data
                                      ?.seasons[index]
                                      ?.season ??
                                  'Season name',
                              seriesImg: tvSeriesSeasonsController?.tvSeriesSeasonsModel?.value?.data?.seasons[index]?.img == null
                                  ? 'https://picsum.photos/100'
                                  : AppUrls.imageBaseUrl +
                                      tvSeriesSeasonsController
                                          ?.tvSeriesSeasonsModel
                                          ?.value
                                          ?.data
                                          ?.seasons[index]
                                          ?.img,
                              nestedId: HomePageFragment.exploreNavId);
                        },
                      ),
                    ),
                  );
                }
              }),

              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TvSeriesSponsoredCard(),
              ),
            ],
          ),
        );
      }
    });
  }
}

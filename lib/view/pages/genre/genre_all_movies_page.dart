import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/genre_all_movies_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/shimmers/grid_shimmer.dart';
import '../action_category/action_category_img_card.dart';
import '../action_category/action_category_sponsored_card.dart';
import '../home/homepage.dart';

class GenreAllMoviesPage extends StatefulWidget {
  final int nestedId;
  final String genreImage;
  final String genreName;

  GenreAllMoviesPage(
      {this.nestedId, @required this.genreImage, @required this.genreName});

  @override
  _GenreAllMoviesPageState createState() => _GenreAllMoviesPageState();
}

class _GenreAllMoviesPageState extends State<GenreAllMoviesPage> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      body: SingleChildScrollView(
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
                            Colors.black.withOpacity(0.7), BlendMode.srcOver),
                        image: ExtendedNetworkImageProvider(
                          '${widget.genreImage}',
                          cache: true,
                          cacheRawData: true,
                          imageCacheName: '${widget.genreImage}',
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
                      '${widget.genreName}',
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: GetBuilder<GenreAllMoviesViewModel>(
                builder: (controller) {
                  bool flag =
                      controller?.genreAllMoviesModel?.data?.data1?.isEmpty ??
                          true;
                  if (controller?.genreAllMoviesModelLoading == true) {
                    return getGridShimmer(wp, hp, itemCount: 1);
                  } else if (flag == true) {
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
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 4 / 5,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: controller
                              ?.genreAllMoviesModel?.data?.data1?.length ??
                          0,
                      itemBuilder: (BuildContext context, int index) =>
                          ActionCategoryImgCard(
                        imgPath: AppUrls.imageBaseUrl +
                                controller?.genreAllMoviesModel?.data
                                    ?.data1[index]?.thumbnail ??
                            "",
                        onTap: () {
                          AppRouter.navToVideoDetailsPage(
                              controller
                                  ?.genreAllMoviesModel?.data?.data1[index],
                              HomePageFragment.exploreNavId,
                              controller?.genreAllMoviesModel?.data
                                  ?.data1[index]?.categoryId);
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionCategorySponsoredCard(),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/genre_all_movies_view_model.dart';
import '../../../core/view_models/genre_view_model.dart';
import '../../../core/view_models/sponsor_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../router/app_router.dart';
import '../../widgets/shimmers/grid_shimmer.dart';
import '../dashboard/cards/sponsored_movie_card.dart';
import 'card/genre_card.dart';
import 'genre_all_movies_page.dart';

class GenrePage extends StatefulWidget {
  final int nestedId;

  GenrePage({this.nestedId});

  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  GenreAllMoviesViewModel genreMoviesController =
      Get.put(GenreAllMoviesViewModel());

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      appBar: IotaAppBar.appBarWithTitle(
        title: "Genre",
        backButtonOnTap: () {
          AppRouter.back();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: GetBuilder<GenreViewModel>(
                  builder: (controller) {
                    if (controller.genreLoading == true) {
                      return getGridShimmer(wp, hp, itemCount: 1);
                    } else if (controller.genreLoading == false &&
                        controller.genreModel.data.isEmpty) {
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
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller?.genreModel?.data?.length ?? 0,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 10,
                          childAspectRatio: 250.0 / 250.0,
                        ),
                        itemBuilder: (_, i) {
                          String genreImage = AppUrls.imageBaseUrl +
                                  controller?.genreModel?.data[i]?.img ??
                              '';
                          String genreName =
                              controller?.genreModel?.data[i]?.name ?? 'Genre';
                          return GenrePageCard(
                            imagePath: genreImage,
                            name: genreName,
                            onTap: () {
                              genreMoviesController?.getGenreAllMoviesMethod(
                                  controller?.genreModel?.data[i]?.id
                                      .toString());
                              Get.to(
                                GenreAllMoviesPage(
                                  genreImage: genreImage,
                                  genreName: genreName,
                                ),
                                transition: Transition.fadeIn,
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: 160,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 3, right: 3),
              //     child: GetBuilder<SponsorViewModel>(
              //       builder: (cntrlr) => SponsoredMovieCard(
              //         model: cntrlr?.sponsorsList[0],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

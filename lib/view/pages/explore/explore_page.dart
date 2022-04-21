import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/view_models/actor_view_model.dart';
import '../../../core/view_models/categories_view_model.dart';
import '../../../core/view_models/country_view_model.dart';
import '../../../core/view_models/genre_view_model.dart';
import '../../../core/view_models/sponsor_view_model.dart';
import '../../../core/view_models/tv_series_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../icons/explore_icons_icons.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_drawer.dart';
import '../actors/actors_page.dart';
import '../base_screen.dart';
import '../country/country_page.dart';
import '../dashboard/cards/sponsored_movie_card.dart';
import '../genre/card/genre_card.dart';
import '../genre/genre_page.dart';
import '../home/homepage.dart';
import '../tv_channel_pages/tv_channel_list_page.dart';
import 'explore_page_card/explore_catagory_card.dart';
import 'explore_page_card/live_tv_ard.dart';
import 'grid_view/app_child_delegate.dart';
import 'grid_view/app_grid_view_delegate.dart';

/// Explore Page
///
/// A UI page contains several features of app, such like
///  * [GenrePage] as a card which contains Genre List
///  * [CountryPage] as a card shich contains County List
///  * [ActorsPage] as a card which contains Actors List
///  * [TvChannelListPage] as card which contains TV Channel list
/// and also contains Video Category List
class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends BaseScreen<ExplorePage> {
  /// Create and Instantiate all controllers those are need to be
  /// for state management
  CountryViewModel countryController = Get.put(CountryViewModel());
  GenreViewModel genreController = Get.put(GenreViewModel());
  ActorViewModel actorController = Get.put(ActorViewModel());
  TvSeriesViewModel tvSeriesViewModel = Get.put(TvSeriesViewModel());
  CategoriesViewModel categoriesViewModel = Get.put(CategoriesViewModel());

  @override
  void initState() {
    super.initState();
    categoriesViewModel.getCategories();
  }

  int spListPos = 0;

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      appBar: IotaAppBar.basicAppBarWithSearchIcon(),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(0),
            child: GetBuilder<CategoriesViewModel>(
              builder: (categoryController) {
                return Container(
                  child: Column(
                    children: [

                      GridView.custom(
                        padding: EdgeInsets.all(10),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: AppGridViewDelegate(
                          3,
                          secondCrossAxisCount: 1,
                          secondChildParIndex: 7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 15,
                          firstChildHeight: wp(33),
                          secondChildHeight: wp(90) * (5 / 11),
                        ),
                        childrenDelegate: AppChildDelegate(
                          secondChildParIndex: 7,
                          children: [
                            ExploreCategoryCard(
                              text: "STATE",
                              iconData: ExploreIcons.country,
                             backgroundColor: Color(0xff6890B8),
                              imagePath: "assets/images/explore_page/country.png",
                              onTap: () {
                                countryController.getCountryMethod();
                                AppRouter.navToCountryPage(
                                    nestedId: HomePageFragment.exploreNavId);
                              },
                            ),
                            ExploreCategoryCard(
                              text: "GENRE",
                              iconData: ExploreIcons.genre,
                              backgroundColor: Color(0xffE15050),
                              imagePath: "assets/images/explore_page/genre.png",
                              onTap: () {
                                genreController.getGenreMethod();
                                AppRouter.navToGenrePage(
                                    nestedId: HomePageFragment.exploreNavId);
                              },
                            ),
                            ExploreCategoryCard(
                              text: "LEGENDS",
                              iconData: ExploreIcons.actor,
                              backgroundColor: Color(0xffEDC33A),
                              imagePath: "assets/images/explore_page/actor.png",
                              onTap: () {
                                actorController.getActorMethod();
                                AppRouter.navToActorPage(
                                    nestedId: HomePageFragment.exploreNavId);
                              },
                            ),
                            LiveTvCard(),
                            ...Iterable.generate(
                                (categoryController?.categoriesModel?.data?.length ??
                                    0), (i) {
                              // if (i % 6 == 0 && i < 10 && i != 0)
                              //   return Container(
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(
                              //           left: 0, right: 0, top: 0, bottom: 0),
                              //       child: GetBuilder<SponsorViewModel>(
                              //         builder: (cntrlr) =>
                              //             cntrlr.exploreSponsorList.length == 0
                              //                 ? Container()
                              //                 : SponsoredMovieCard(
                              //                     model: cntrlr?.exploreSponsorList[
                              //                         (spListPos++ %
                              //                             cntrlr.exploreSponsorList
                              //                                 .length)],
                              //                   ),
                              //       ),
                              //     ),
                              //   );
                              // if (((i + 4) - 10) % 7 == 0)
                              //   return Container(
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(
                              //           left: 0, right: 0, top: 0, bottom: 0),
                              //       child: GetBuilder<SponsorViewModel>(
                              //         builder: (cntrlr) => SponsoredMovieCard(
                              //           model: cntrlr?.exploreSponsorList[
                              //               (spListPos++ %
                              //                   cntrlr.exploreSponsorList.length)],
                              //         ),
                              //       ),
                              //     ),
                              //   );
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, bottom: 0, top: 0),
                                child: GenrePageCard(

                                  imagePath: AppUrls.imageBaseUrl +
                                          categoryController
                                              ?.categoriesModel?.data[i]?.img ??
                                      "",
                                  name: categoryController
                                          ?.categoriesModel?.data[i]?.name ??
                                      '',
                                  onTap: () {
                                    categoryController.getSubCategories(
                                        id: categoryController
                                            ?.categoriesModel?.data[i]?.id);

                                    AppRouter.navToActionCategoryPage(
                                        catName: categoryController
                                            ?.categoriesModel?.data[i]?.name,
                                        catImage: AppUrls.imageBaseUrl +
                                            categoryController
                                                ?.categoriesModel?.data[i]?.img,
                                        nestedId: HomePageFragment.exploreNavId);
                                    // }
                                  },
                                ),
                              );
                                }),

                            GenrePageCard(
                              imagePath: "https://bharatmata.info/public/img/tvSeriesCover.jpg",
                              name: "Spiritual Series",
                              onTap: () {
                                AppRouter.navToTvSeriesCategoryPage(
                                    nestedId: HomePageFragment.exploreNavId);
                              },
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}

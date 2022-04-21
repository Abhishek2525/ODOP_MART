import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/view_models/country_all_videos_view_model.dart';
import '../../../core/view_models/country_view_model.dart';
import '../../../core/view_models/sponsor_view_model.dart';
import '../../../view/cards/app_bars/app_bar_with_title.dart';
import '../../../view/router/app_router.dart';
import '../dashboard/cards/sponsored_movie_card.dart';
import 'card/country_card.dart';
import 'country_all_movies_page.dart';

class CountryPage extends StatefulWidget {
  final int nestedId;

  CountryPage({this.nestedId});

  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  @override
  void initState() {
    super.initState();
  }

  final CountryAllMoviesViewModel countryAllMoviesController =
      Get.put(CountryAllMoviesViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IotaAppBar.appBarWithTitle(
        title: "Country",
        backButtonOnTap: () {
          AppRouter.back();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<CountryViewModel>(
                builder: (controller) => Container(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        controller?.countryModelRx?.value?.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 10,
                      childAspectRatio: 250.0 / 250.0,
                    ),
                    itemBuilder: (_, i) {
                      String countryImage = AppUrls.imageBaseUrl +
                              controller?.countryModelRx?.value?.data[i]?.img ??
                          '';
                      String countryName =
                          controller?.countryModelRx?.value?.data[i]?.title ??
                              'Country';
                      return CountryCard(
                        countryFlagPath: countryImage,
                        countryName: countryName,
                        onTap: () {
                          countryAllMoviesController.getCountryAllMoviesMethod(
                            id: controller?.countryModelRx?.value?.data[i]?.id
                                .toString(),
                          );
                          Get.to(
                            CountryAllMoviesPage(
                              countryFlagImage: countryImage,
                              countryName: countryName,
                            ),
                          );
                        },
                      );
                    },
                  ),
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

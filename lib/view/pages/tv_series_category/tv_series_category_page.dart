import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/view_models/tv_series_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../home/homepage.dart';
import 'tv_series_img_card.dart';
import 'tv_series_sponsored_card.dart';

class TvSeriesCategoryPage extends StatefulWidget {
  final int nestedId;

  TvSeriesCategoryPage({this.nestedId});

  @override
  _TvSeriesCategoryPageState createState() => _TvSeriesCategoryPageState();
}

class _TvSeriesCategoryPageState extends State<TvSeriesCategoryPage> {
  TvSeriesViewModel controller = Get.put(TvSeriesViewModel());

  @override
  Widget build(BuildContext context) {
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// top banner
            Stack(
              children: [
                Container(
                  height: hp(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.srcOver),
                        image: AssetImage(
                          'images/tvSeriesCover.jpg',
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
                      'Spiritual Series',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: 'poppins_bold',
                        // fontWeight: FontWeight.bold,
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

            /// tv series grid view
            _tvSeriesListGridview(),
            SizedBox(
              height: 10,
            ),

            /// bottom sponsor banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TvSeriesSponsoredCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tvSeriesListGridview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Obx(() {
        if (controller.tvSeriesLoading.value == true) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (controller.tvSeriesLoading.value == false &&
            controller.tvSeriesModel.value.data.isEmpty) {
          return Center(
            child: Text('No tv series found'),
          );
        } else {
          return GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4 / 5,
                mainAxisSpacing: 10),
            itemCount: controller?.tvSeriesModel?.value?.data?.length ?? 0,
            itemBuilder: (BuildContext context, int index) => TVSeriesImgCard(
              imgPath: AppUrls.imageBaseUrl +
                  controller?.tvSeriesModel?.value?.data[index]?.img,
              onTap: () {
                AppRouter.navToTvSeriesSeasonsPage(
                    id: controller?.tvSeriesModel?.value?.data[index]?.id
                        ?.toString(),
                    nestedId: HomePageFragment.exploreNavId);
              },
              seriesName: controller?.tvSeriesModel?.value?.data[index]?.name,
            ),
          );
        }
      }),
    );
  }
}

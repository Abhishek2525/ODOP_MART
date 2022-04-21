import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/categories_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/shimmers/grid_shimmer.dart';
import '../home/homepage.dart';
import 'action_category_img_card.dart';
import 'action_category_sponsored_card.dart';

class SubActionCategoryPage extends StatefulWidget {
  final String catName;
  final int nestedId;
  final String catImage;

  SubActionCategoryPage({this.nestedId, this.catName, this.catImage});

  @override
  _SubActionCategoryPageState createState() => _SubActionCategoryPageState();
}

class _SubActionCategoryPageState extends State<SubActionCategoryPage> {
  CategoriesViewModel catController = Get.put(CategoriesViewModel());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;

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
                              Colors.black.withOpacity(0.7), BlendMode.srcOver),
                          fit: BoxFit.cover,
                          image: ExtendedNetworkImageProvider(
                            widget?.catImage ?? 'https://picsum.photos/200',
                            cache: true,
                            cacheRawData: true,
                            imageCacheName:
                                widget?.catImage ?? 'https://picsum.photos/200',
                          ),
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
                  InkResponse(
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
                if (catController.videoLoading.value == true) {
                  return Center(
                    child: getGridShimmer(wp, hp),
                  );
                } else if (catController
                    .subCategoryAllVideosModel.value.data.data1.isEmpty) {
                  return Container(
                    height: wp(50),
                    width: wp(50),
                    child: Image.asset(noDataImagePath),
                  );
                } else {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          child: Text(
                            'Videos',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                        ),
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
                            itemCount: catController?.subCategoryAllVideosModel
                                    ?.value?.data?.data1?.length ??
                                0,
                            itemBuilder: (BuildContext context, int index) =>
                                ActionCategoryImgCard(
                              imgPath: catController
                                          ?.subCategoryAllVideosModel
                                          ?.value
                                          ?.data
                                          ?.data1[index]
                                          ?.thumbnail !=
                                      null
                                  ? AppUrls.imageBaseUrl +
                                      catController?.subCategoryAllVideosModel
                                          ?.value?.data?.data1[index]?.thumbnail
                                  : "https://picsum.photos/60",
                              onTap: () {
                                AppRouter.navToVideoDetailsPage(
                                    catController?.subCategoryAllVideosModel
                                        ?.value?.data?.data1[index],
                                    HomePageFragment.exploreNavId,
                                    catController?.subCategoryAllVideosModel
                                        ?.value?.data?.data1[index].categoryId);
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
}

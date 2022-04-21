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
import '../genre/card/genre_card.dart';
import '../home/homepage.dart';
import 'action_category_img_card.dart';
import 'action_category_sponsored_card.dart';

class ActionCategoryPage extends StatefulWidget {
  final String catName;
  final int nestedId;
  final String catImage;

  ActionCategoryPage({this.nestedId, this.catName, this.catImage});

  @override
  _ActionCategoryPageState createState() => _ActionCategoryPageState();
}

class _ActionCategoryPageState extends State<ActionCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;

    CategoriesViewModel catController = Get.put(CategoriesViewModel());

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.srcOver),
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
                            color: Colors.black38)
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget?.catName ?? "Category name",
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
              Obx(() {
                bool isDarkTheme = ThemeController.currentThemeIsDark;
                String noDataImagePath = ImageNames.noDataForDarkTheme;
                if (isDarkTheme == false) {
                  noDataImagePath = ImageNames.noDataForLightTheme;
                }

                bool flag = catController
                    ?.subCategoriesModel?.value?.data?.subcategory?.isEmpty;
                bool flag2 = catController
                    ?.subCategoryAllVideosModel?.value?.data?.data1?.isEmpty;

                if (catController.subCategoryLoading.value) {
                  return Center(
                    child: getGridShimmer(wp, hp),
                  );
                } else if ((flag != null && flag == true) &&
                    (flag2 != null && flag2 == true)) {
                  return Container(
                    alignment: Alignment.center,
                    height: wp(50),
                    width: wp(50),
                    child: Image.asset(noDataImagePath),
                  );
                } else {
                  return Visibility(
                    visible: !(flag ?? true),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Text(
                              'Sub Categories',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10),
                                itemCount: catController?.subCategoriesModel
                                        ?.value?.data?.subcategory?.length ??
                                    0,
                                itemBuilder: (BuildContext context, int index) {
                                  return GenrePageCard(
                                    imagePath: catController
                                                ?.subCategoriesModel
                                                ?.value
                                                ?.data
                                                ?.subcategory[index]
                                                ?.img !=
                                            null
                                        ? AppUrls.imageBaseUrl +
                                            catController
                                                ?.subCategoriesModel
                                                ?.value
                                                ?.data
                                                ?.subcategory[index]
                                                ?.img
                                        : "https://picsum.photos/60",
                                    name: catController
                                            ?.subCategoriesModel
                                            ?.value
                                            ?.data
                                            ?.subcategory[index]
                                            ?.name ??
                                        'name',
                                    onTap: () {
                                      catController.getSubCategoriesAllVideos(
                                          id: catController
                                              ?.subCategoriesModel
                                              ?.value
                                              ?.data
                                              ?.subcategory[index]
                                              .id);
                                      AppRouter.navToSubActionCategoryPage(
                                        nestedId: HomePageFragment.exploreNavId,
                                        catName: catController
                                            ?.subCategoriesModel
                                            ?.value
                                            ?.data
                                            ?.subcategory[index]
                                            ?.name,
                                        catImage: catController
                                                    ?.subCategoriesModel
                                                    ?.value
                                                    ?.data
                                                    ?.subcategory[index]
                                                    ?.img !=
                                                null
                                            ? AppUrls.imageBaseUrl +
                                                catController
                                                    ?.subCategoriesModel
                                                    ?.value
                                                    ?.data
                                                    ?.subcategory[index]
                                                    ?.img
                                            : "https://picsum.photos/60",
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
              SizedBox(
                height: 15,
              ),
              Obx(() {
                bool flag = catController?.subCategoriesModel?.value?.data
                    ?.categoryVideo?.data1?.isEmpty;

                if (catController.videoLoading.value) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (flag != null && flag) {
                  return Container();
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
                            horizontal: 10,
                            vertical: 0,
                          ),
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
                            itemCount: catController?.subCategoriesModel?.value
                                    ?.data?.categoryVideo?.data1?.length ??
                                0,
                            itemBuilder: (BuildContext context, int index) =>
                                ActionCategoryImgCard(
                              imgPath: catController
                                          ?.subCategoriesModel
                                          ?.value
                                          ?.data
                                          ?.categoryVideo
                                          ?.data1[index]
                                          ?.thumbnail !=
                                      null
                                  ? AppUrls.imageBaseUrl +
                                      catController
                                          ?.subCategoriesModel
                                          ?.value
                                          ?.data
                                          ?.categoryVideo
                                          ?.data1[index]
                                          ?.thumbnail
                                  : "https://picsum.photos/60",
                              onTap: () {
                                AppRouter.navToVideoDetailsPage(
                                  catController?.subCategoriesModel?.value?.data
                                      ?.categoryVideo?.data1[index],
                                  HomePageFragment.exploreNavId,
                                  catController?.subCategoriesModel?.value?.data
                                      ?.categoryVideo?.data1[index].categoryId,
                                );
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

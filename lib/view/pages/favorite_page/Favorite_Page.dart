import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/view_models/fevorite_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/shimmers/list_shimmer.dart';
import '../base_screen.dart';
import 'widget/FavoriteCards.dart';

/// A stateful widget represent a Single Page called Favorite Page
class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends BaseScreen<FavoritePage> {
  int rebuild = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
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
                AssetImage(
                  'images/searchIcon.png',
                ),
                size: 18,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          child: Container(
            color: AppColors.deepRed,
            height: .5,
          ),
          preferredSize: Size.fromHeight(1.5),
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: 10.0,
          ),
          child: GetBuilder<FavoriteViewModel>(
            builder: (c) {
              int len = c?.allFavoriteModel?.value?.data?.length ?? 0;
              if (c.favoriteDataLoading.value == true &&
                  c.firstTimeHere == true) {
                return getListShimmer(wp, hp);
              }
              if (c.favoriteDataLoading.value == false && len == 0) {
                bool isDarkTheme = ThemeController.currentThemeIsDark;
                String noDataImagePath = ImageNames.noDataForDarkTheme;
                if (isDarkTheme == false) {
                  noDataImagePath = ImageNames.noDataForLightTheme;
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: wp(30),
                        width: wp(30),
                        child: Image.asset(noDataImagePath),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (c?.allFavoriteModel?.value?.data?.length ?? 0),
                  itemBuilder: (BuildContext context, int index) {
                    return FavoriteItemCard(
                      index: index,
                      imgPath:
                          (c?.allFavoriteModel?.value?.data[index]?.thumbnail),
                      model: c?.allFavoriteModel?.value?.data[index],
                      onDelete: () async {
                        var model =
                            c?.allFavoriteModel?.value?.data?.removeAt(index);
                        setState(() {});
                        int res =
                            await c.deleteFavoriteData(model?.id?.toString());
                        if (res == 200) {
                          Toast.show("Favorite Data removed", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                          //c?.getFavoriteData();
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
  }
}

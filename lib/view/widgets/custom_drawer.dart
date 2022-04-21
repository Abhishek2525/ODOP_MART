import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/api/app_urls.dart';
import '../../core/utils/local_auth/local_auth_get_storage.dart';
import '../../core/view_models/profile_view_model.dart';
import '../../core/view_models/theme_view_model.dart';
import '../../main.dart';
import '../constant/app_colors.dart';
import '../pages/home/homepage.dart';
import '../router/app_router.dart';
import 'rating/rating_bottom_sheet.dart';

/// This [Widget] is the [NavigationDrawer] of our app
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool visible = LocalDBUtils.getJWTToken() != null;

    bool isDarkTheme = ThemeController.currentThemeIsDark;

    TextStyle drawerItemTextStyle = TextStyle(
      color: Theme.of(context).textTheme.headline1.color,
    );
    return Drawer(
      elevation: 50,
      child: GetBuilder<ProfileViewModel>(
        builder: (controller) {
          return Container(
            color: isDarkTheme
                ? AppColors.darkScaffoldBackgroundColor
                : Theme.of(context).appBarTheme.backgroundColor,
            child: Column(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/card.jpg"),
                   // image: MemoryImage(drawerImage),
                    fit: BoxFit.cover,
                  )
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (LocalDBUtils.getJWTToken() != null) {
                            AppRouter.navToProfileWithLogIn();
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            CircleAvatar(
                              radius: 25,
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                  border: Border.all(
                                      color: Colors.white, width: .5),
                                  image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(controller
                                                ?.profileModel?.data?.avatar ==
                                            null
                                        ? 'https://picsum.photos/100'
                                        : AppUrls.imageBaseUrl +
                                            controller
                                                ?.profileModel?.data?.avatar),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Center(
                                  child: Text(
                                    controller?.profileModel?.data?.name ?? "",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                )),
                                Container(
                                  child: Center(
                                    child: Text(
                                      controller?.profileModel?.data?.email ??
                                          "",
                                      style: TextStyle(
                                        color: AppColors.appAmber,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      /// home tile
                      _drawerTile(
                        title: 'Home',
                        image: 'images/homeImg.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToHomePage(
                            fragment: HomePageFragment.dashboard,
                          );
                          Get.back();
                        },
                      ),
                      _getDivider(),

                      /// explore tile
                      _drawerTile(
                        title: 'Explore',
                        image: 'images/ExploreImg.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToHomePage(
                              fragment: HomePageFragment.explore);
                        },
                      ),
                      _getDivider(),

                      /// video tile
                      _drawerTile(
                        title: 'Videos',
                        image: 'images/videoImg.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToHomePage(
                              fragment: HomePageFragment.live);
                        },
                      ),
                      Visibility(
                        visible: visible,
                        child: _getDivider(),
                      ),

                      /// favorite tile
                      Visibility(
                        visible: visible,
                        child: _drawerTile(
                          title: 'Favorite',
                          image: 'images/favorite.png',
                          drawerItemTextStyle: drawerItemTextStyle,
                          onTap: () {
                            AppRouter.navToHomePage(
                                fragment: HomePageFragment.favourite);
                          },
                        ),
                      ),

                      Visibility(
                        visible: visible,
                        child: _getDivider(),
                      ),

                      /// history tile
                      Visibility(
                        visible: visible,
                        child: _drawerTile(
                          title: 'History',
                          image: 'images/history.png',
                          drawerItemTextStyle: drawerItemTextStyle,
                          onTap: () {
                            AppRouter.navToHistoryPage();
                          },
                        ),
                      ),
                      _getDivider(),

                      /// download tile
                      _drawerTile(
                        title: 'My Downloads',
                        image: 'images/settingDrawer.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToDownloadPage();
                        },
                      ),
                      _getDivider(),

                      /// settings tile
                      _drawerTile(
                        title: 'Settings',
                        image: 'images/settingDrawer.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToSettingScreen();
                        },
                      ),
                      _getDivider(),

                      /// help and feedback tile
                      _drawerTile(
                        title: 'Help & Feedback',
                        image: 'images/helpDrawer.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToHelpFeedbackPage();
                        },
                      ),
                      _getDivider(),

                      /// share tile
                      _drawerTile(
                        title: 'Share',
                        image: 'images/share.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToSharePage();
                        },
                      ),
                      _getDivider(),

                      /// rate us tile
                      _drawerTile(
                        title: 'Rate Us',
                        image: 'images/rateus.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () async {
                          Navigator.pop(context);
                          await BottomSheetRating.bottomSheetPro(context);
                        },
                      ),
                      _getDivider(),

                      /// subscribe add free tile
                      _drawerTile(
                        title: 'Subscribe Ad free',
                        image: 'images/subscribe.png',
                        drawerItemTextStyle: drawerItemTextStyle,
                        onTap: () {
                          AppRouter.navToSubscriptionPlan();
                        },
                      ),
                      _getDivider(),

                      /// logout tile
                      Visibility(
                        visible: visible,
                        child: _drawerTile(
                          title: 'Log Out',
                          image: 'images/logout.png',
                          drawerItemTextStyle: drawerItemTextStyle,
                          onTap: () {
                            var profileViewModel = Get.put(ProfileViewModel());
                            profileViewModel.getLogoutMethod();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8, top: 10),
                  child: Text(
                    'Version 1.01.01',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawerTile({
    @required String title,
    @required String image,
    @required TextStyle drawerItemTextStyle,
    @required Function onTap,
  }) {
    return ListTile(
      dense: true,
      title: Row(
        children: [
          ImageIcon(
            AssetImage(image),
            size: 26,
            color: AppColors.shadowRed,
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: drawerItemTextStyle,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _getDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        color: AppColors.dividerColor,
        height: 8,
        thickness: .3,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

import '../../../core/controllers/deep_linking_controller.dart';
import '../../../core/middle_ware/route_objerver.dart';
import '../../../core/models/home_categories_model.dart';
import '../../../core/repo/deep_link_repo/deep_link_repo.dart';
import '../../../core/utils/local_auth/local_auth_get_storage.dart';
import '../../../core/view_bindings/action_category_page_bindings.dart';
import '../../../core/view_bindings/home_page_bindings.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../action_category/action_category_page.dart';
import '../all_video_page/all_video_page.dart';
import '../dashboard/dashboard_screen.dart';
import '../explore/explore_page.dart';
import '../favorite_page/Favorite_Page.dart';
import '../profile_with_login/profile_with_login.dart';
import '../profile_without_login/profile_without_login.dart';
import 'bottom_bar/bottom_bar.dart';

class HomePageFragment {
  /// routes navigation ID`s
  static const int dashboardNavId = 1;
  static const int exploreNavId = 2;
  static const int liveNavId = 3;
  static const int favouriteNavId = 4;
  static const int profileNavId = 5;

  /// route names
  static const String dashboard = "dashboard";
  static const String explore = "explore";
  static const String live = "live";
  static const String favourite = "favourite";
  static const String profile = "profile";

  /// return pages index by their names
  static getInitialIndex(String page) {
    if (page == dashboard) return 0;
    if (page == explore) return 1;
    if (page == live) return 2;
    if (page == favourite) return 3;
    if (page == profile) return 4;
  }
}

/// HomePage
///
/// this widget contains all widgets and provide functionality of applications
/// [HomePage] * [Dashboard], [ExplorePage], [AllVideoPage], [FavoritePage],
/// [ProfileWithLogIn], [ProfileWithoutLogIn]
///
/// Provide a Bottom Navigation bar to navigate various pages
///
/// Provide a Navigation Drawer to Navigate various pages
class HomePage extends StatefulWidget {
  /// Page name that should be visible in [HomePage]
  final String page;

  HomePage({this.page = HomePageFragment.dashboard});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  /// This field represent Currently selected page
  ///
  /// This defaults to 'dashboard'
  String currentPage = 'dashboard';

  @override
  void initState() {
    super.initState();
    currentPage = widget.page;

    /// if user enter from deep linking then send user to video details page
    if (DeepLinkingController.deepLinkingPerformed == false) {
      DeepLinkingController.deepLinkingPerformed = true;
      Future.delayed(Duration(seconds: 2)).then((value) {
        initUniLinks();
      });
    }
  }

  /// Handle Deep Linking
  ///
  /// This method detect if a user enter in app by clicking any link that
  /// has been shared withing this app by any other user.
  ///
  /// If user enter to this app by clicking deep link then this method
  /// detect the event and do specific work according to event
  Future<void> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();
      print('MyApp.initUniLinks ** ' + 'init link = $initialLink');

      if (initialLink != null && initialLink.isNotEmpty) {
        List<String> lst = initialLink.split('/');
        String id = lst[lst.length - 1];
        Get.to(ProgressDialog(message: 'Video is loading...'), opaque: false);
        HomeData homeData = await DeepLinkRepo().getVideoFromDeepLink(id);
        Get.back();
        if (homeData != null) {
          AppRouter.navToVideoDetailsPage(homeData, 0, homeData.categoryId);
        }
      }
    } on PlatformException {}
  }

  /// A map contains fragment widgets for [HomePage]
  ///
  /// Fragment Widgets it contains are [Dashboard], [ExplorePage], [AllVideoPage],
  /// [FavoritePage], [ProfileWithLogIn]
  ///
  /// Provide fragment according to BottomNavigation Bar`s Item onTap
  Map<String, Widget> pageView = <String, Widget>{
    "dashboard": Navigator(
        key: Get.nestedKey(HomePageFragment.dashboardNavId),
        initialRoute: "/",
        onUnknownRoute: (settings) {
          return GetPageRoute(
            page: () => Dashboard(),
          );
        },
        onGenerateRoute: (settings) {
          print("nestedKey:-  $settings ");
          if (settings.name == "/ActionCategoryPage") {
            return GetPageRoute(
              routeName: "/ActionCategoryPage",
              page: () => ActionCategoryPage(),
            );
          }
          return GetPageRoute(
            page: () => Dashboard(),
          );
        }),
    "explore": Navigator(
        key: Get.nestedKey(HomePageFragment.exploreNavId),
        initialRoute: "/",
        onUnknownRoute: (settings) {
          return GetPageRoute(
            page: () => ExplorePage(),
          );
        },
        onGenerateRoute: (settings) {
          print("nestedKey:-  $settings ");
          if (settings.name == "/ActionCategoryPage") {
            return GetPageRoute(
              routeName: "/ActionCategoryPage",
              page: () => ActionCategoryPage(),
            );
          }
          return GetPageRoute(
            page: () => ExplorePage(),
          );
        }),
    "live": Navigator(
        key: Get.nestedKey(HomePageFragment.liveNavId),
        initialRoute: "/",
        onGenerateRoute: (settings) {
          print("nestedKey:-  $settings ");
          if (settings.name == "/ActionCategoryPage") {
            return GetPageRoute(
              routeName: "/ActionCategoryPage",
              page: () => ActionCategoryPage(),
              binding: ActionCategoryPageBindings(),
            );
          }
          return GetPageRoute(
            page: () => AllVideoPage(),
            binding: HomePageBindings(),
          );
        }),
    "favourite": Navigator(
      key: Get.nestedKey(HomePageFragment.favouriteNavId),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        return GetPageRoute(page: () => FavoritePage());
      },
    ),
    "profile": Navigator(
      key: Get.nestedKey(HomePageFragment.profileNavId),
      initialRoute: "/",
      onGenerateRoute: (settings) {
        String token = LocalDBUtils.getJWTToken();
        return GetPageRoute(
          routeName: "/profile",
          page: () => token == null
              ? ProfileWithoutLogIn(
                  nestedId: HomePageFragment.profileNavId,
                )
              : ProfileWithLogIn(
                  nestedId: HomePageFragment.profileNavId,
                ),
        );
      },
    ),
  };

  /// This method performs changing page according to Bottom Navigation Bar
  /// item selection
  changePage(String pageName) {
    AdsMiddleWare.clickCountIncrement();
    if (currentPage == pageName) {
      switch (pageName) {
        case HomePageFragment.dashboard:
          Get.nestedKey(HomePageFragment.dashboardNavId)
              .currentState
              .popUntil((route) => route.isFirst);
          break;
        case HomePageFragment.explore:
          Get.nestedKey(HomePageFragment.exploreNavId)
              .currentState
              .popUntil((route) => route.isFirst);
          break;
        case HomePageFragment.live:
          Get.nestedKey(HomePageFragment.liveNavId)
              .currentState
              .popUntil((route) => route.isFirst);
          break;
        case HomePageFragment.favourite:
          Get.nestedKey(HomePageFragment.favouriteNavId)
              .currentState
              .popUntil((route) => route.isFirst);
          break;
        case HomePageFragment.profile:
          Get.nestedKey(HomePageFragment.profileNavId)
              .currentState
              .popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      setState(() {
        currentPage = pageName;
      });
    }
  }

  /// This method returns AppBar in terms of which page is currently selected
  Widget getAppBar() {
    if (currentPage == HomePageFragment.dashboard) {
      return null;
    } else if (currentPage == HomePageFragment.explore)
      return null;
    else if (currentPage == HomePageFragment.live) {
      return null;
    } else if (currentPage == HomePageFragment.favourite) return null;

    return null;
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Scaffold(
        appBar: getAppBar(),
        drawer: CustomDrawer(),
        bottomNavigationBar: AppBottomBar(
          page: widget?.page,
          changePage: changePage,
        ),
        body: pageView[currentPage],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  /// This method detect current Page Back Button onTap and allow to customize
  /// the back button onTap activity
  ///
  /// In our case we will show user a Dialog for confirmation,
  /// is user realy wants to leave the application
  Future<bool> _willPop() async {
    final value = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Text(
            'Are you sure you want to exit?',
            style: TextStyle(color: AppColors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No',
                style: TextStyle(color: AppColors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Yes, exit',
                style: TextStyle(color: AppColors.deepRed),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return value == true;
  }
}

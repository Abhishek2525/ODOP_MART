import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../../core/view_bindings/Update_user_profile_bindings.dart';
import '../../core/view_bindings/settings_page_bindings.dart';
import '../../core/view_bindings/sign_in_page_bindings.dart';
import '../../core/view_bindings/sign_up_page_bindongs.dart';
import '../../core/view_bindings/video_details_bindings.dart';
import '../pages/explore/explore_search_page.dart';
import '../pages/favorite_page/Favorite_Page.dart';
import '../pages/help_feedback/help_feedback_page.dart';
import '../pages/profile_with_login/edit_profile.dart';
import '../pages/profile_with_login/profile_with_login.dart';
import '../pages/setting_page/setting_screen.dart';
import '../pages/share/share_page.dart';
import '../pages/signin_page/Sign_In_Page.dart';
import '../pages/signup_page/signup_page.dart';
import '../pages/splash/SplashScreen.dart';
import '../pages/video_details/video_details_page.dart';

/// done 100 lines
class AppPageNavigator {
  static List<GetPage> getPages = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(
      name: '/SignInPage',
      page: () => SignInPage(),
      binding: SignInPageBindings(),
    ),
    GetPage(
      name: '/SignUpPage',
      page: () => SignUpPage(),
      binding: SignUpPageBinding(),
    ),
    GetPage(
      name: '/FavoritePage',
      page: () => FavoritePage(),
    ),
    GetPage(
      name: "/ExploreSearchPage",
      page: () => ExploreSearchPage(),
    ),
    GetPage(
      name: "/EditProfilePage",
      page: () => EditProfilePage(),
      binding: UpdateUserProfileBindings(),
    ),
    GetPage(name: "/ProfileWithLogIn", page: () => ProfileWithLogIn()),
    GetPage(
      name: "/SettingScreen",
      page: () => SettingScreen(),
      transition: Transition.fadeIn,
      binding: SettingsPageBindings(),
    ),
    GetPage(name: '/HelpFeedbackPage', page: () => HelpFeedbackPage()),
    GetPage(name: '/SharePage', page: () => SharePage()),
    GetPage(
      name: '/VideoDetailsPage',
      page: () => VideoDetailsPage(),
      binding: VideoDetailsBindings(Get.arguments),
    ),
  ];
}

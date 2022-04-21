import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iotflixcinema/core/services/premium_video_services.dart';

import '../../core/models/home_categories_model.dart';
import '../../core/models/tv_series_seasons_model.dart';
import '../../core/view_bindings/Update_user_profile_bindings.dart';
import '../../core/view_bindings/action_category_page_bindings.dart';
import '../../core/view_bindings/actor_page_bindings.dart';
import '../../core/view_bindings/country_bindings.dart';
import '../../core/view_bindings/feedback_bindings.dart';
import '../../core/view_bindings/genre_page_bindings.dart';
import '../../core/view_bindings/history_bindings/history_bindings.dart';
import '../../core/view_bindings/home_page_bindings.dart';
import '../../core/view_bindings/search/search_bindings.dart';
import '../../core/view_bindings/settings_page_bindings.dart';
import '../../core/view_bindings/sign_in_page_bindings.dart';
import '../../core/view_bindings/sign_up_page_bindongs.dart';
import '../../core/view_bindings/sub_scribe_page_bindings.dart';
import '../../core/view_bindings/tv_series_video_details_bindings.dart';
import '../../core/view_bindings/video_details_bindings.dart';
import '../pages/about_app/about_app_page.dart';
import '../pages/action_category/action_category_page.dart';
import '../pages/action_category/sub_action_category_page.dart';
import '../pages/actors/actors_all_movies_page.dart';
import '../pages/actors/actors_page.dart';
import '../pages/cookie_policy/cookie_policy.dart';
import '../pages/country/country_all_movies_page.dart';
import '../pages/country/country_page.dart';
import '../pages/dashboard/home_categories_more_videos_page.dart';
import '../pages/download_page/download_page.dart';
import '../pages/explore/explore_search_page.dart';
import '../pages/favorite_page/Favorite_Page.dart';
import '../pages/genre/genre_all_movies_page.dart';
import '../pages/genre/genre_page.dart';
import '../pages/help_feedback/help_feedback_page.dart';
import '../pages/history_page/history_page.dart';
import '../pages/home/homepage.dart';
import '../pages/privacy_policy/pricavy_policy.dart';
import '../pages/profile_with_login/edit_profile.dart';
import '../pages/profile_with_login/profile_with_login.dart';
import '../pages/saiful_tv_series_pages/saiful_tv_series_details_binding.dart';
import '../pages/saiful_tv_series_pages/saiful_tv_series_details_page.dart';
import '../pages/setting_page/setting_screen.dart';
import '../pages/share/share_page.dart';
import '../pages/signin_page/Sign_In_Page.dart';
import '../pages/signup_page/signup_page.dart';
import '../pages/subcribe/sub_cribe_page.dart';
import '../pages/terms_of_use/terms_of_use.dart';
import '../pages/tv_series_category/individual_season_page.dart';
import '../pages/tv_series_category/tv_series_category_page.dart';
import '../pages/tv_series_category/tv_series_seasons_page.dart';
import '../pages/tv_series_video_details/tv_series_video_details_page.dart';
import '../pages/video_details/video_details_more_videospage.dart';
import '../pages/video_details/video_details_page.dart';
import 'router_state.dart';

/// Provide Navigation through the Application
///
/// provides methods to Navigate specific page or route
class AppRouter {
  static int nestedId;

  static setNestedId(int id) {
    nestedId = id;
  }

  static back({dynamic result, int nestedId}) {
    RouterState.pop(nestedId ?? -1);
    return Get.back(result: result, id: nestedId);
  }

  /// Navigate to [SignInPage] page
  static navToSignInPage() {
    return Get.offAll(
      SignInPage(),
      binding: SignInPageBindings(),
    );
  }

  /// Navigate to [SignUpPage]
  static navToSignUpPage() {
    return Get.to(
      SignUpPage(),
      binding: SignUpPageBinding(),
    );
  }

  /// Navigate t0 [FavoritePage] page
  static navToFavoritePage() {
    return Get.to(FavoritePage());
  }

  /// Navigate to [ExploreSearchPage] page
  static navToExploreSearchPage({int nestedId}) {
    return Get.to(
      ExploreSearchPage(),
      id: nestedId,
      transition: Transition.fadeIn,
      binding: SearchBindings(),
    );
  }

  /// Navigate to [EditProfilePage] page
  static navToEditProfilePage({int nestedId}) {
    return Get.to(
      EditProfilePage(),
      binding: UpdateUserProfileBindings(),
      id: nestedId,
    );
  }

  /// Navigate to [ProfileWithLogIn]
  static navToProfileWithLogIn() {
    return Get.to(ProfileWithLogIn());
  }

  /// Navigate to [SettingScreen] page
  static navToSettingScreen() {
    return Get.to(
      SettingScreen(),
      transition: Transition.fadeIn,
      binding: SettingsPageBindings(),
    );
  }

  static navToDownloadPage() {
    return Get.to(
      DownloadPage(),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate tp [HelpFeedbackPage] page
  static navToHelpFeedbackPage() {
    return Get.to(
      HelpFeedbackPage(),
      binding: FeedbackBindings(),
    );
  }

  /// Navigate to [SharePage] page
  static navToSharePage() {
    return Get.to(
      SharePage(),
    );
  }

  /// Navigate to [AboutAppPage] page
  static navToAboutAppPage({
    String title,
    String version,
    String mail,
    String url,
    String moreApp,
    String developedBy,
    String copyRight,
    String description,
  }) {
    return Get.to(AboutAppPage(
      title: title,
      url: url,
      copyRight: copyRight,
      developedBy: developedBy,
      mail: mail,
      moreApp: moreApp,
      version: version,
      description: description,
    ));
  }

  /// Navigate to [GenrePage] page
  static navToGenrePage({int nestedId}) {
    return Get.to(
      GenrePage(
        nestedId: nestedId,
      ),
      binding: GenrePageBindings(),
    );
  }

  /// Navigate to [CountryPage]
  static navToCountryPage({int nestedId}) {
    return Get.to(
      CountryPage(
        nestedId: nestedId,
      ),
      binding: CountryBindings(),

    );
  }

  /// Navigate to [ActorsPage] page
  static navToActorPage({int nestedId}) {
    return Get.to(
      ActorsPage(
        nestedId: nestedId,
      ),
      binding: ActorPageBindings(),
    );
  }

  /// Navigate to [SubScribePage] page
  static navToSubscriptionPlan() {
    return Get.to(
      SubScribePage(),
      transition: Transition.fadeIn,
      binding: SubScribePageBindings(),
    );
  }

  /// Navigate to [ActionCategoryPage] page
  static navToActionCategoryPage(
      {int nestedId, String catName, String catImage}) {
    return Get.to(
      ActionCategoryPage(
        catName: catName,
        catImage: catImage,
        nestedId: nestedId,
      ),
      binding: ActionCategoryPageBindings(),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [ActorsAllMoviesPage] page
  static navToActorsAllMoviesPage(
      {int nestedId,
      String catName,
      String catImage,
      bool fromVideoDetailsPage}) {
    return Get.to(
      ActorsAllMoviesPage(
        catName: catName,
        catImage: catImage,
        nestedId: nestedId,
        fromVideoDetailsPage: true,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [HomeCategoryMoreVideosPage] page
  static navToMoreVideosPage({
    String catName,
    String catImage,
    List<HomeData> homeDataList,
  }) {
    return Get.to(
      HomeCategoryMoreVideosPage(
        catName: catName,
        catImage: catImage,
        listModel: homeDataList,
      ),
      binding: ActionCategoryPageBindings(),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [VideoDetailsMoreVideosPage] page
  static navToVideoDetailsMoreVideosPage({
    int nestedId,
    String catName,
    String catImage,
    List<HomeData> homeDataList,
  }) {
    return Get.to(
      VideoDetailsMoreVideosPage(
        catName: catName,
        catImage: catImage,
        nestedId: nestedId,
        listModel: homeDataList,
      ),
      binding: ActionCategoryPageBindings(),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [SubActionCategoryPage] page
  static navToSubActionCategoryPage(
      {int nestedId, String catName, String catImage}) {
    return Get.to(
      SubActionCategoryPage(
        catName: catName,
        catImage: catImage,
        nestedId: nestedId,
      ),
      binding: ActionCategoryPageBindings(),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [GenreAllMoviesPage] page
  static navToGenreAllMoviesPage({int nestedId}) {
    return Get.to(
      GenreAllMoviesPage(
        genreName: '',
        genreImage: '',
        nestedId: nestedId,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [CountryAllMoviesPage] page
  static navToCountryAllMoviesPage({int nestedId}) {
    return Get.to(
      CountryAllMoviesPage(
        countryFlagImage: '',
        countryName: '',
        nestedId: nestedId,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [TvSeriesCategoryPage] page
  static navToTvSeriesCategoryPage({int nestedId}) {
    return Get.to(
      TvSeriesCategoryPage(
        nestedId: nestedId,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [TvSeriesSeasonsPage] page
  static navToTvSeriesSeasonsPage({String id, int nestedId}) {
    return Get.to(
      TvSeriesSeasonsPage(
        id: id,
        nestedId: nestedId,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [IndividualSeasonPage] page
  static navToIndividualSeasonPage(
      {List<Episodes> episodes,
      String seasonTitle,
      String seriesName,
      String seriesImg,
      int nestedId}) {
    return Get.to(
      IndividualSeasonPage(
        episodes: episodes,
        seasonTitle: seasonTitle,
        seriesName: seriesName,
        seriesImg: seriesImg,
        nestedId: nestedId,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [TvSeriesVideoDetailsPage] page
  static navToTvSeriesVideoDetailsPage(HomeData model,
      {Episodes episodes,
      String seriesName,
      String seasonTitle,
      int nestedId}) {
    return Get.to(
      TvSeriesVideoDetailsPage(
        episodes: episodes,
        seriesName: seriesName,
        seasonTitle: seasonTitle,
        nestedId: nestedId,
      ),
      binding: TvSeriesVideoDetailsBindings(model),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [VideoDetailsPage] page
  static navToVideoDetailsPage(HomeData model, int nestedId, int catId) async{
    bool isPremium = model?.isPremium == 1 ? true: false;
    if(isPremium){
      if(PremiumVideoServices.userIsAPremiumUser()){
        return await Get.to(
          VideoDetailsPage(
            nestedId: nestedId,
            catId: catId,
            videoId: model?.id,
          ),
          transition: Transition.fadeIn,
          binding: VideoDetailsBindings(model),
        );
      }
    }else{
      return await Get.to(
        VideoDetailsPage(
          nestedId: nestedId,
          catId: catId,
          videoId: model?.id,
        ),
        transition: Transition.fadeIn,
        binding: VideoDetailsBindings(model),
      );
    }
  }

  /// Navigate to [SaifulTvSeriesDetailsPage] page
  static navToSaifulTvseriesDetailsPage(
      List<HomeData> modelList, HomeData model, int nestedId, int catId) {

    bool isPremium = model?.isPremium == 1 ? true: false;
    print('\n\n${jsonEncode(model)}\n\n');

    if(isPremium == false){
      return Get.to(
        SaifulTvSeriesDetailsPage(
          nestedId: nestedId,
          catId: catId,
          videoId: model?.id,
        ),
        transition: Transition.fadeIn,
        binding: SaifulTvSeriesDetailsBinding(model, modelList),
      );
    }

    if(PremiumVideoServices.userIsAPremiumUser() == true){
      return Get.to(
        SaifulTvSeriesDetailsPage(
          nestedId: nestedId,
          catId: catId,
          videoId: model?.id,
        ),
        transition: Transition.fadeIn,
        binding: SaifulTvSeriesDetailsBinding(model, modelList),
      );
    }
  }

  /// Navigate to [HomePage] page
  static navToHomePage({String fragment}) {
    return Get.offAll(
      HomePage(
        page: fragment ?? HomePageFragment.dashboard,
      ),
      transition: Transition.fadeIn,
      binding: HomePageBindings(),
    );
  }

  /// Navigate to [HistoryPage] page
  static navToHistoryPage({int nestedId}) {
    RouterState.push(nestedId ?? -1, "HistoryPage");
    return Get.to(
      HistoryPage(
        nestedId: nestedId,
      ),
      transition: Transition.fadeIn,
      binding: HistoryBindings(),
    );
  }

  /// Navigate to [PrivacyPolicy] page
  static navToPrivacyPolicy({@required String privacyPolicyText}) {
    return Get.to(
      PrivacyPolicy(
        privacyPolicyText: privacyPolicyText,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [TermsOfUsePage] page
  static navToTermsOfUsePage({String termUseText}) {
    return Get.to(
      TermsOfUsePage(
        termUseText: termUseText,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Navigate to [CookiePolicy] page
  static navToCookiePolicy({String policyText}) {
    return Get.to(
      CookiePolicy(
        policyText: policyText,
      ),
      transition: Transition.fadeIn,
    );
  }

  /// Leave from app from anywhere in the application
  static exitApp() {
    exit(0);
  }
}

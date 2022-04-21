/// This class is designed for holding all API URL's those are used within
/// this project.
class AppUrls {
  /// base url
  static String baseUrl = "https://bharatmata.info/";

  /// deep linking base url
  static String deepLinkingBaseUrl = 'https://bharatmata.info/videoappvideo/';

  /// image base url
  static String imageBaseUrl = "${baseUrl}storage/";

  ///user
  static String registerUserUrl = baseUrl + "api/user/register";
  static String loginUserUrl = baseUrl + "api/user/login";

  static String homeBannerUrl = baseUrl + "api/home/banners";
  static String countryUrl = baseUrl + "api/country/getall";
  static String genreUrl = baseUrl + "api/genres";
  static String actorUrl = baseUrl + "api/actor/getAll";
  static String actorsMoviesUrl = baseUrl + "api/actor/videos/";

  static String sponsorUrl = baseUrl + "api/sponsors";
  static String allVideosUrl = baseUrl + "api/videos";
  static String likeUrl = baseUrl + "api/video/like";
  static String dislikeUrl = baseUrl + "api/video/dislike";
  static String categoriesUrl = baseUrl + "api/categories/andorid/video";
  static String categoryMayLike = baseUrl + "api/category/maylike?id=";
  static String subCategoriesUrl = baseUrl + "api/categories/subcategory/";
  static String subCategoriesAllVideosUrl = baseUrl + "api/subcategory/video/";
  static String tvSeriesUrl = baseUrl + "api/series";
  static String homeCategoriesUrl = baseUrl + "api/home/videos";
  static String videoDetailsUrl = baseUrl + "api/videos/";
  static String settingsUrl = baseUrl + "api/settings";
  static String genreAllMoviesUrl = baseUrl + "api/genres/videos/";
  static String countryAllMoviesUrl = baseUrl + "api/country/videos/";
  static String logoutUserUrl = baseUrl + "api/user/logout";
  static String profileUrl = baseUrl + "api/user/me";
  static String updateProfileUrl = baseUrl + "api/user/update";
  static String historyUrl = baseUrl + "api/user/hirstory";
  static String addReportsUrl = baseUrl + "api/report";
  static String tvSeriesSeasonsUrl = baseUrl + "api/series/episodes/";
  static String feedbackUrl = baseUrl + "api/feedback";

  /// This method return an URl for filtering videos from server.
  static String filterVideoUrl(
      {int totalLike,
      String time,
      List<int> resolutions,
      List<int> categoryIds,
      List<String> subCategoryIds}) {
    /// generate a string from resolution list to use in filter api
    String reso = resolutions.toString();
    String resolutionString = '';
    for (int i = 0; i < reso.length; i++) {
      if (reso[i] != ' ' && reso[i] != '[' && reso[i] != ']') {
        resolutionString += reso[i];
      }
    }

    /// generate a string from video category id list to use in filter api
    String cat = categoryIds.toString();
    String categoryString = '';
    for (int i = 0; i < cat.length; i++) {
      if (cat[i] != ' ' && cat[i] != '[' && cat[i] != ']') {
        categoryString += cat[i];
      }
    }

    if (categoryString.isNotEmpty) {
      categoryString += ',';
    }

    /// generate a string from subcategory id list to use in filter api
    String subCat = subCategoryIds.toString();
    for (int i = 0; i < subCat.length; i++) {
      if (subCat[i] != ' ' && subCat[i] != '[' && subCat[i] != ']') {
        categoryString += subCat[i];
      }
    }

    String ur = baseUrl +
        "api/video/filter?total_like=$totalLike&upload_type=$time&resolution[]=$resolutionString&category_id[]=$categoryString";

    print(ur);

    return ur;
  }

  static String tvSeriesSeasonEpisodeUrl =
      baseUrl + "api/series/suggestion/withfilter";

  ///wishList
  static String wishListAllUrl = baseUrl + "api/wishlist/getall";
  static String wishListSingleDeleteUrl = baseUrl + "api/wishlist/delete/";
  static String addWishList = baseUrl + "api/wishlist";

  /// This url used to check, is a video favorite video
  static String isFavUrl(String id) => baseUrl + 'api/videos/isFavorite/$id';

  ///video view count url
  static String addToHistoryUrl = baseUrl + "api/view/add";
  static String deleteSingleHistory =
      baseUrl + "api/user/historysingle/delete/";

  ///search urls
  static String searchSuggestion = "$baseUrl" + "api/search/suggestions";
  static String searchResult = "$baseUrl" + "api/search/results";

  /// tv channel url
  static String getAllTvChannelUrl = '${baseUrl}api/channels';

  /// ads config url
  static String adsConfigUrl = "${baseUrl}api/ads/active";

  /// only category list url
  static String getOnlyCategoryListUrl = '${baseUrl}api/categories/video';

  /// get resolution list api url
  static String getResulutionListUrl = '${baseUrl}api/video-resolution';

  /// get sub category list by category id url
  static String getSubcategoryListBuCategoryIdUrl(String categoryId) =>
      '${baseUrl}api/categories/only-subcategory/$categoryId';

  /// vide view count api url
  static String addVideoViewCountUrl = '${baseUrl}api/view/add';

  /// app info api url
  static String appInfoApiUrl = '${baseUrl}api/settings';

  /// stripe payment url
  static String stripePaymentUrl = '${baseUrl}api/stripe/create';

  /// paypal payment url
  static String payPalPaymentUrl = '${baseUrl}api/paypal/create';
}

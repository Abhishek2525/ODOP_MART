import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../view/router/app_router.dart';
import '../../../view/widgets/shimmers/video_details_shimmer.dart';
import '../../api/app_urls.dart';
import '../../models/home_categories_model.dart';
import '../../models/search/search_result_model.dart';
import '../../repo/search/search_repo.dart';

/// A [Get] controller for state management
class SearchViewModel extends GetxController {
  /// indicate the state of search operation
  Rx<bool> searching = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSearchSuggestion();
    searchQuery();
  }

  /// get search suggestions from server
  getSearchSuggestion() async {
    List<String> tempList = await SearchRepo().getSearchSuggestion();
    searchSuggestion?.assignAll(tempList);
    searching.value = false;
    update();
  }

  /// This method perform the actual search operation based on query
  /// And save the result to [SearchResultModel]
  searchQuery({String value}) async {
    searching.value = true;
    update();
    SearchResultModel temp = SearchResultModel();
    await temp.callApi(value: value);
    searchResultModel = temp;
    searching.value = false;
    update();
  }

  /// Add a keyword to suggestions list
  addToSuggestionList(String s) {
    if (s == null) return;
    searchSuggestion?.add(s);
  }

  /// [RxList] for search suggestions
  RxList<String> searchSuggestion = RxList();

  /// This field contains the result of search operation
  SearchResultModel searchResultModel = SearchResultModel();

  /// This method specially designed for
  /// get video from server for deep linking feature
  ///
  /// this method hit getVideoById api and after a success response
  /// it navigate to video details page to play the video
  Future<void> getSingleVIdeoAndNavigateToVideoDetailsScreen(dynamic id) async {
    Get.to(FullVideoDetailsSHimmer());

    try {
      String url = AppUrls.baseUrl + 'api/videos/$id';

      final response = await http.get(Uri.parse(url));
      Get.back();

      if (response.statusCode == 200) {
        var resMap = jsonDecode(response.body);

        if (resMap['status'] == true) {
          VideoModel videoData = VideoModel.fromJson(resMap['data']);

          ///Navigate to video details aoge
          AppRouter.navToVideoDetailsPage(videoData, 0, videoData.categoryId);
          return;
        }
      }
    } catch (error) {
      Get.back();
      print('catched error = $error');
    }
    Get.rawSnackbar(message: 'Video not available');
  }
}

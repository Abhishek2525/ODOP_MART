import 'package:get/get.dart';

import '../../api/app_urls.dart';
import '../../api/http_request.dart';

/// A repository class to perform network operation,
/// to getting search suggestions strings from server
///
class SearchRepo extends GetConnect {
  Future<List<String>> getSearchSuggestion() async {
    try {
      Map<String, dynamic> res = await HttpHelper.get(AppUrls.searchSuggestion);
      if (res == null) return [];
      if (res['status'] == false) return [];
      List t = res['data'];

      List<String> searchList = [];

      t.forEach((element) {
        searchList?.add(element?.toString());
      });

      return searchList;
    } catch (e) {
      return [];
    }
  }
}

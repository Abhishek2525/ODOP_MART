import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../view/pages/history_page/history_page.dart';
import '../../../view/widgets/dialogs/progress_dialog.dart';
import '../../api/app_urls.dart';
import '../../utils/local_auth/local_auth_get_storage.dart';
import '../../view_models/history_view_model/history_view_model.dart';

/// A repository class to perform network operation,
///
/// related to [HistoryPage] pages
class HistoryAddRepo extends GetConnect {
  /// This method makes a network call and add a video to history list
  addToHistory(String id) async {
    if (id == null) return;

    if (LocalDBUtils.getJWTToken() == null) {
      await postVideoViewCount(body: {'video_id': "$id"});
      return;
    }
    String token = "Bearer " + LocalDBUtils.getJWTToken();

    Map<String, String> headers = {"Authorization": "$token"};

    await postVideoViewCount(headers: headers, body: {'video_id': "$id"});
  }

  /// This method make an api call and increase the view count of a video
  Future<void> postVideoViewCount(
      {Map<String, String> headers, Map<String, String> body}) async {
    try {
      String url = AppUrls.addVideoViewCountUrl;
      final response = await http.post(
        Uri.parse(url),
        headers: headers ?? {},
        body: body,
      );

      if (response.statusCode == 200) {}
    } catch (exception) {}
  }

  /// This method makes an network call and delete a video history from server
  deleteHistorySingle(String id) async {
    if (id == null) return;

    if (LocalDBUtils.getJWTToken() == null) return;
    String token = "Bearer " + LocalDBUtils.getJWTToken();
    print("Bearer token :- \n");
    print(token);

    Map<String, String> headers = {"Authorization": "$token"};

    try {
      Response r =
          await delete(AppUrls.deleteSingleHistory + "$id", headers: headers);
      print(r?.statusCode);
      print(r?.body);
      return r?.statusCode;
    } catch (e, t) {
      print(e);
      print(t);
      return 404;
    }
  }

  /// This method call an api and delete all history data from server for a user
  Future<void> deleteAllHistory() async {
    String url = '${AppUrls.baseUrl}api/user/history/delete';
    try {
      Get.to(() => ProgressDialog());
      if (LocalDBUtils.getJWTToken() == null) return;

      String token = "Bearer " + LocalDBUtils.getJWTToken();
      Map<String, String> headers = {"Authorization": "$token"};

      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        HistoryViewModel historyViewModel = Get.put(HistoryViewModel());
        historyViewModel.firstTime.value = true;
        historyViewModel.refreshHistoryListAfterClearAllHistory();
      } else {}
      Get.back();
    } catch (exception) {}
  }
}

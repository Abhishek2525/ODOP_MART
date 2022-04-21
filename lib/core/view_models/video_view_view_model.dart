import 'package:get/get.dart';

import '../models/home_categories_model.dart';
import '../repo/vedio_view/history_add_repo.dart';

/// A [GetxController] to manage app states and performing logical operations
class VideoViewViewModel extends GetxController {
  Rx<HomeData> model;

  Rx<bool> videoInInitialState = true.obs;

  /// This method used for initialize [model] field
  setModel(HomeData data) {
    videoInInitialState.value = true;
    model = data.obs;
  }

  /// This method add a video to history list in the server
  historyAddMethod(String id) async {
    HistoryAddRepo().addToHistory(id);
  }

  /// This method perform delete operation of a single history
  /// from server
  deleteSingleHistory(String id) async {
    return await HistoryAddRepo().deleteHistorySingle(id);
  }
}

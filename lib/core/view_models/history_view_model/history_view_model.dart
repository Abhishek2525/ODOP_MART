import 'package:get/get.dart';

import '../../../view/pages/history_page/history_page.dart';
import '../../models/history/history_data_model.dart';

/// A [Get] controller for state management of [HistoryPage] widget
class HistoryViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getHistoryData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// This method refresh the controller to apply the changes
  refreshHistoryListAfterClearAllHistory() async {
    historyDataModel?.value?.data?.data?.clear();
    historyDataModel?.refresh();
  }

  /// Get history data
  getHistoryData({int page = 1}) async {
    historyLoading.value = true;
    await tempModel?.callApi(page: page);
    historyLoading.value = false;
    historyDataModel?.value = tempModel;
    historyDataModel?.refresh();
  }

  /// This field contains the history data
  Rx<HistoryDataModel> historyDataModel = HistoryDataModel().obs;

  /// This field indicate the history data loading or not
  Rx<bool> historyLoading = true.obs;

  Rx<bool> firstTime = true.obs;
  HistoryDataModel tempModel = HistoryDataModel();
}

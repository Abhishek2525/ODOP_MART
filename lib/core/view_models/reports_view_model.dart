import 'package:get/get.dart';

import '../../view/widgets/dialogs/progress_dialog.dart';
import '../models/add_reports_model.dart';

/// This is a [GetxController] used for managing app state
///
/// Provide functionality to Place a report for a video
class ReportsViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  /// This method performs the actual Place report operation
  getAddReportsMethod({
    String id,
    String description,
  }) async {
    Get.to(ProgressDialog(), opaque: false);
    try {
      await addReportsModel.callApi(id: id, description: description);
      update();
      Get.back();
    } catch (e) {
      Get.back();
      print(e);
    }
  }

  AddReportsModel addReportsModel = AddReportsModel();
}

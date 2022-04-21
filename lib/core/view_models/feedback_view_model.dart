import 'package:get/get.dart';

import '../models/feedback_model.dart';

/// A [GetxController] for controller App feedback
class FeedbackViewModel extends GetxController {
  @override
  void onClose() {
    super.onClose();
  }

  /// This method post a feedback to the server
  getFeedbackMethod({
    String name,
    String phone,
    String email,
    String feedback,
  }) async {
    await feedbackModel.callApi(
        phone: phone, name: name, email: email, feedback: feedback);
    update();
  }

  FeedbackModel feedbackModel = FeedbackModel();
}

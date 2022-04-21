import 'package:get/get.dart';

import '../view_models/feedback_view_model.dart';

class FeedbackBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(FeedbackViewModel());
  }
}

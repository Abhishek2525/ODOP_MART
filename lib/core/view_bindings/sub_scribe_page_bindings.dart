import 'package:get/get.dart';

import '../view_models/theme_view_model.dart';

class SubScribePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
  }
}

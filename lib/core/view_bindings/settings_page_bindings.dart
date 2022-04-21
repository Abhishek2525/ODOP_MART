import 'package:get/get.dart';

import '../view_models/settings_view_model.dart';
import '../view_models/theme_view_model.dart';

class SettingsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(SettingsViewModel());
  }
}

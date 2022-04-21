import 'package:get/get.dart';

import '../view_models/profile_view_model.dart';

class UpdateUserProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileViewModel());
  }
}

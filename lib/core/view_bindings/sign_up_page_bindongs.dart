import 'package:get/get.dart';

import '../view_models/register_user_view_model.dart';

class SignUpPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterUserViewModel());
  }
}

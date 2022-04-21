import 'package:get/get.dart';

import '../view_models/sign_in_view_model.dart';

class SignInPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInViewModel());
  }
}

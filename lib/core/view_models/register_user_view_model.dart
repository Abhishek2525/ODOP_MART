import 'package:get/get.dart';

import '../../view/router/app_router.dart';
import '../../view/widgets/dialogs/progress_dialog.dart';
import '../models/register_user_model.dart';

/// A [GetxController]
///
/// For performing user registration
class RegisterUserViewModel extends GetxController {
  RegisterUserModel registerUserModel = RegisterUserModel();

  /// This method performs Registration operation for user
  void registerUserMethod({
    String email,
    String name,
    String password,
    String phone,
    String registerMethod,
    String fbOrGoogleId,
  }) async {
    Get.to(ProgressDialog(), opaque: false);

    await registerUserModel.callApi(
      name: name,
      email: email,
      phone: phone,
      password: password,
      registerMethod: registerMethod,
      fbOrGoogleId: fbOrGoogleId,
    );

    Get.back();

    update();

    if (registerUserModel?.data?.bearerToken != null) {
      AppRouter.navToSignInPage();
    } else {
      errorMsgEmail = registerUserModel?.errors?.email?.first ?? "";
      errorMsgPhone = registerUserModel?.errors?.phone?.first ?? "";
    }
  }

  String errorMsgEmail = "";
  String errorMsgPhone = "";
}

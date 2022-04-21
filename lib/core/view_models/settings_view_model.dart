import 'package:get/get.dart';

import '../../view/pages/about_app/about_app_page.dart';
import '../../view/pages/privacy_policy/pricavy_policy.dart';
import '../../view/pages/setting_page/setting_screen.dart';
import '../../view/pages/terms_of_use/terms_of_use.dart';
import '../models/settings_model.dart';

/// A [GetxController] to manage app state specially designed for
/// managing state of [SettingScreen], [AboutAppPage], [PrivacyPolicy],
/// [TermsOfUsePage], pages
class SettingsViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getSettingsMethod();
  }

  /// This field represents a data model object that contains apps all information
  SettingsModel settingsModel = SettingsModel();

  /// Call an api and get app information from server
  getSettingsMethod() async {
    await settingsModel.callApi();
    update();
  }
}

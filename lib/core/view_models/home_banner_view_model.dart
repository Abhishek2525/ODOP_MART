import 'package:get/get.dart';

import '../models/home_banner_model.dart';

/// A [GetxController] designed for providing functionality
/// of [HomeBanner] Widget
class HomeBannerViewModel extends GetxController {
  HomeBannerModel homeBannerModel = HomeBannerModel();

  @override
  void onInit() {
    super.onInit();

    getBannerMethod();
  }

  /// This method makes an api call and retrieve Banner Images from Network
  getBannerMethod() async {
    await homeBannerModel.callApi();
    update();
  }
}

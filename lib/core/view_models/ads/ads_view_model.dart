import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import '../../ads/interstitial_ads.dart';
import '../../models/ads/ads_config_model.dart';
import '../../repo/ads/ads_config_repo.dart';

class AdsViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getAdsConfig();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future getAdsConfig() async {
    AdsConfigRepo repo = AdsConfigRepo();
    config = await repo.getAdsConfig();
    if (!kIsWeb) AppInterstitialAds.getInstance..initial();
  }

  AdsConfig config;
}

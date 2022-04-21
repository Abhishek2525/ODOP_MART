import 'package:get/get.dart';

import '../ads/interstitial_ads.dart';
import '../view_models/ads/ads_view_model.dart';

/// A middleware class to keep trace of app navigation count and showing add[openAds]
class AdsMiddleWare {
  static int _clickCount = 0;

  /// A method to increment app navigation count and show add based on navigation count
  static clickCountIncrement() {
    _clickCount++;
    if (_clickCount % (_adsViewModel?.config?.clickCount ?? 5) == 0) {
      openAds();
    }
  }

  static AdsViewModel _adsViewModel = Get.find();

  /// open insterstitial Ads
  static openAds() {
    AppInterstitialAds.getInstance.loadAds(_adsViewModel?.config?.type);
  }
}

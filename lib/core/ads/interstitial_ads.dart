import 'package:flutter/foundation.dart';

//import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:get/get.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../view_models/ads/ads_view_model.dart';

/// Contains add category names
class AdsName {
  static String fb = "facebook";
  static String google = "google";
  static String unity = "unity";
  static String noAds = "noAds";
}

class AppInterstitialAds {
  static AppInterstitialAds _instance;

  AppInterstitialAds._();

  static AppInterstitialAds get getInstance =>
      _instance ??= AppInterstitialAds._();

  // InterstitialAd myInterstitial;
  //
  // AdListener listener;
  // AdsViewModel _adsViewModel = Get.find();

  initial() {
    /// This is the add listener listen to the add state and does specific work
    // listener = AdListener(
    //   onAdLoaded: (Ad ad) => print('Ad loaded.'),
    //   onAdFailedToLoad: (Ad ad, LoadAdError error) {
    //     ad.dispose();
    //     myInterstitial?.load();
    //   },
    //   onAdOpened: (Ad ad) => print('Ad opened.'),
    //   onAdClosed: (Ad ad) {
    //     ad.dispose();
    //     myInterstitial?.load();
    //   },
    //   onApplicationExit: (Ad ad) => print('Left application.'),
    // );

    /// load interstitial ad
    // myInterstitial = InterstitialAd(
    //   adUnitId: _adsViewModel.config?.interstitialAd,
    //   request: AdRequest(),
    //   listener: listener,
    // );
    //
    // myInterstitial?.load();

    /// face book ads

    //FacebookAudienceNetwork.init();
  }

  /// This method loads google ad
  loadGoogleAds() async {
  //  await myInterstitial?.load();
  //  await myInterstitial?.show();
  }

  /// This method loads facebook ad
  loadFacebookAds() {
    // FacebookInterstitialAd.loadInterstitialAd(
    //   placementId: _adsViewModel.config?.interstitialAd,
    //   listener: (result, value) {
    //     print("facebook event:- $result -> $value");
    //     if (result == InterstitialAdResult.LOADED)
    //       FacebookInterstitialAd.showInterstitialAd(delay: 0);
    //   },
    // );
  }

  /// This method loads ad depending on [adsName]
  loadAds(String adsName) {
    /// do nothing if platform is web
    if (kIsWeb) return;

    /*if (adsName?.trim()?.toLowerCase() == AdsName.fb.toLowerCase()) {
      loadFacebookAds();
    } else */
      if (adsName?.trim()?.toLowerCase() == AdsName.google.toLowerCase()) {
      loadGoogleAds();
    } else if (adsName?.trim()?.toLowerCase() == AdsName.unity.toLowerCase()) {}
  }
}

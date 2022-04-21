import 'dart:async';

import 'package:flutter/material.dart';

//import 'package:facebook_audience_network/ad/ad_native.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
//import 'package:flutter_native_admob/native_admob_controller.dart';
//import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:get/get.dart';

import '../../view_models/ads/ads_view_model.dart';

/// A StateFull Widget To show Native ad
class NativeAds extends StatefulWidget {
  final String adsName;

  NativeAds({@required this.adsName});

  @override
  _NativeAdsState createState() => _NativeAdsState();
}

class _NativeAdsState extends State<NativeAds> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (widget.adsName?.toLowerCase() == "google")
      return Container(
        child: AdMobNativeAds(),
        width: size.width * 0.95,
      );
    // else if (widget.adsName?.toLowerCase() == "facebook")
    //   return Container(
    //     child: NativeFbAds(),
    //     width: size.width * 0.95,
    //   );
    else
      return Container();
  }
}

class AdMobNativeAds extends StatefulWidget {
  @override
  _AdMobNativeAdsState createState() => _AdMobNativeAdsState();
}

class _AdMobNativeAdsState extends State<AdMobNativeAds> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  //NativeAdmobController nativeAdController = NativeAdmobController();
  /*StreamSubscription _subscription;

  googleAdeMob() {
    _subscription = nativeAdController.stateChanged.listen((event) {
      _onStateChanged(event);
      if (AdLoadState.loadCompleted == event) {
      } else if (AdLoadState.loading == event) {}
    });
  }

  double _height = 0;

  /// This method does ad state specific work
  /// Whether ad is loading or loadedCompleted
  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
          showAds = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 245;
          showAds = true;
        });
        break;

      default:
        break;
    }
  }

  bool showAds = false;

  @override
  void dispose() {
    _subscription?.cancel();
    nativeAdController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    googleAdeMob();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsViewModel>(
      builder: (c) => Visibility(
        visible: true ?? showAds,
        child: Container(
          height: _height,
          width: _height == 0 ? 0 : null,
          child: Container(
            height: _height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: NativeAdmob(
              options: NativeAdmobOptions(),
              adUnitID: c.config.nativeAd,
              controller: nativeAdController,
              type: NativeAdmobType.full,
            ),
          ),
        ),
      ),
    );
  }
}

class NativeFbAds extends StatelessWidget {
  const NativeFbAds({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsViewModel>(
      builder: (c) => Container(
        child: Center(
          // child: FacebookNativeAd(
          //   placementId: c.config?.nativeAd,
          //   adType: NativeAdType.NATIVE_BANNER_AD,
          //   keepAlive: true,
          //   keepExpandedWhileLoading: false,
          //   expandAnimationDuraion: 300,
          //   listener: (result, value) {},
          // ),
        ),
      ),
    );
  }*/
}

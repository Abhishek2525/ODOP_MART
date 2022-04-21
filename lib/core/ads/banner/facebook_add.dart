import 'package:flutter/material.dart';

//import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:get/get.dart';

import '../../view_models/ads/ads_view_model.dart';

/// A state less widget to show Facebook ad
class FaeBookAdd extends StatefulWidget {
  final double height;
  final double width;

  FaeBookAdd({
    this.height,
    this.width,
  });

  @override
  _FaeBookAddState createState() => _FaeBookAddState();
}

class _FaeBookAddState extends State<FaeBookAdd> {
  @override
  void initState() {
    super.initState();
   // FacebookAudienceNetwork.init();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsViewModel>(
      builder: (c) => Container(
        // height: BannerSize.STANDARD.height.toDouble(),
        // width: BannerSize.STANDARD.width.toDouble(),
        // child: Container(
        //   //  alignment: Alignment(0.5, 1),
        //   child: FacebookBannerAd(
        //     placementId: c.config?.bannerAd,
        //     bannerSize: BannerSize.STANDARD,
        //     listener: (result, value) {
        //       switch (result) {
        //         case BannerAdResult.ERROR:
        //           print("Error: $value");
        //           break;
        //         case BannerAdResult.LOADED:
        //           print("Loaded: $value");
        //           break;
        //         case BannerAdResult.CLICKED:
        //           print("Clicked: $value");
        //           break;
        //         case BannerAdResult.LOGGING_IMPRESSION:
        //           print("Logging Impression: $value");
        //           break;
        //       }
        //     },
        //   ),
        // ),
      ),
    );
  }
}

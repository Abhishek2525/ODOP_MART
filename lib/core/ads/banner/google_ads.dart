import 'package:flutter/material.dart';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:get/get.dart';

import '../../view_models/ads/ads_view_model.dart';

/// A StateLess Widget
///
/// Responsible for showing Google Ad
class GoogleBannerOLDAdd extends StatefulWidget {
  /// Height of ad view
  final double height;

  /// Width of ad view
  final double width;

  GoogleBannerOLDAdd({
    this.width,
    this.height,
  });

  @override
  _GoogleAddState createState() => _GoogleAddState();
}

class _GoogleAddState extends State<GoogleBannerOLDAdd> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  /// Size of admod Banner
  //AdmobBannerSize bannerSize;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
   // bannerSize = AdmobBannerSize.ADAPTIVE_BANNER(
   //     width: widget?.width?.toInt() ?? AdmobBannerSize.BANNER.width.toInt());
  }

  /// This method Handle Goggle add events and do event specific work
  // void handleEvent(
  //     AdmobAdEvent event, Map<String, dynamic> args, String adType) {
  //   switch (event) {
  //     case AdmobAdEvent.loaded:
  //       break;
  //     case AdmobAdEvent.opened:
  //       break;
  //     case AdmobAdEvent.closed:
  //       break;
  //     case AdmobAdEvent.failedToLoad:
  //       break;
  //     case AdmobAdEvent.rewarded:
  //       showDialog(
  //         context: scaffoldState.currentContext,
  //         builder: (BuildContext context) {
  //           return WillPopScope(
  //             child: AlertDialog(
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Text('Reward callback fired. Thanks Andrew!'),
  //                   Text('Type: ${args['type']}'),
  //                   Text('Amount: ${args['amount']}'),
  //                 ],
  //               ),
  //             ),
  //             onWillPop: () async {
  //               return true;
  //             },
  //           );
  //         },
  //       );
  //       break;
  //     default:
  //       print(event);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: GetBuilder<AdsViewModel>(
      //   builder: (c) => AdmobBanner(
      //     adUnitId: c.config?.bannerAd,
      //     adSize: bannerSize,
      //     listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      //       handleEvent(event, args, 'Banner');
      //     },
      //   ),
      // ),
    );
  }
}

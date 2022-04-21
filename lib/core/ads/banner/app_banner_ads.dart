import 'package:flutter/material.dart';

import 'facebook_add.dart';
import 'google_ads.dart';

/// A widget, responsible for showing banner ad for facebook or google ad
/// returns a widget based on add type Google or Facebook
class AppBannerAds extends StatelessWidget {
  const AppBannerAds({
    Key key,
    this.adsName,
  }) : super(key: key);
  final String adsName;

  /// if ad type
  bool getGoogleName() {
    if (adsName?.toLowerCase() == "google") {
      return true;
    }
    return false;
  }

  bool getFBName() {
    if (adsName?.toLowerCase() == "facebook") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (getGoogleName()) return GoogleBannerOLDAdd();
   /* if (getFBName()) return FaeBookAdd();*/
    return Container();
  }
}

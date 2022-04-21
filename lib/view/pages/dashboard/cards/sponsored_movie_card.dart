import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../../core/ads/native_ad/native_ads.dart';
import '../../../../core/api/app_urls.dart';
import '../../../../core/models/sponsor_model.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/view_models/ads/ads_view_model.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class SponsoredMovieCard extends StatefulWidget {
  final SponsorData model;

  SponsoredMovieCard({this.model});

  @override
  _SponsoredMovieCardState createState() => _SponsoredMovieCardState();
}

class _SponsoredMovieCardState extends State<SponsoredMovieCard> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    // if (widget.model == null) {
    //   return GetBuilder<AdsViewModel>(
    //     builder: (c) => Container(
    //       padding: EdgeInsets.symmetric(horizontal: 5),
    //       child: NativeAds(
    //         adsName: c.config?.type,
    //       ),
    //     ),
    //   );
    // } else
    //   if (widget.model.action == "disable") {
    //   return GetBuilder<AdsViewModel>(
    //     builder: (c) => Container(
    //       padding: EdgeInsets.symmetric(horizontal: 5),
    //       child: NativeAds(
    //         adsName: c.config?.type,
    //       ),
    //     ),
    //   );
    // } else {
      return InkWell(
        onTap: () {
          AppUtils.launchURL(widget.model.url);
        },
        child: Stack(
          children: [
            Container(
              width: wp(100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.model.img != null
                      ? AppUrls.imageBaseUrl + widget.model.img
                      : '${AppUrls.imageBaseUrl}images/sponsor/lhC5KCSkoTT0xYNudxVudJxsRls3YpQs6lXWnvFL.jpeg',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, imgEvent) {
                    if (imgEvent == null) {
                      return child;
                    } else {
                      return getImageShimmer(
                          height: double.maxFinite, width: wp(100));
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.deepRed,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  child: Text(
                    'Sponsored',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    widget.model?.title ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
   // }
  }
}

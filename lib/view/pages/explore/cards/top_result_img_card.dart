import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/api/app_urls.dart';
import '../../../../core/constant/app_constant.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class TopResultImgCard extends StatelessWidget {
  final String imageUrl;
  final Function ontap;

  TopResultImgCard(this.imageUrl, this.ontap);

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: GestureDetector(
        onTap: () {
          ontap();
        },
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FadeInImage(
              width: wp(29),
              fit: BoxFit.cover,
              image: ExtendedNetworkImageProvider(
                AppUrls.imageBaseUrl + "$imageUrl",
                cache: true,
                cacheRawData: true,
                imageCacheName: AppUrls.imageBaseUrl + "$imageUrl",
              ),
              placeholder: AssetImage(
                ImageNames.thumbPlaceHolder,
              ),
              fadeInDuration: Duration(milliseconds: 300),
              placeholderErrorBuilder: (context, object, stackTrae) {
                return getImageShimmer(height: double.infinity, width: wp(29));
              },
            ),
          ),
        ),
      ),
    );
  }
}

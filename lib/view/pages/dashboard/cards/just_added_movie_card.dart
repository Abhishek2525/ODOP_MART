import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/api/app_urls.dart';
import '../../../../core/constant/app_constant.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

/// this widget represent a single movie card in homepage
/// dhiplay movie card and perform on tap operation

class JustAddedMovieCard extends StatelessWidget {
  final String imgPath;
  final Function onTap;

  JustAddedMovieCard({
    this.imgPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: FadeInImage(
            width: wp(29),
            height: double.infinity,
            fit: BoxFit.cover,
            placeholder: AssetImage(
              ImageNames.thumbPlaceHolder,
            ),
            fadeInDuration: Duration(milliseconds: 300),
            placeholderErrorBuilder: (context, object, stackTrae) {
              return getImageShimmer(height: double.infinity, width: wp(29));
            },
            image: ExtendedNetworkImageProvider(
              '${AppUrls.imageBaseUrl + imgPath}',
              cache: true,
              cacheRawData: true,
              imageCacheName: '${AppUrls.imageBaseUrl + imgPath}',
            ),
            imageErrorBuilder: (context, object, stackTrae) {
              return getImageShimmer(height: double.infinity, width: wp(29));
            },
          ),
        ),
      ),
    );
  }
}

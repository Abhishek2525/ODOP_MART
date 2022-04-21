import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/constant/app_constant.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class RandomMovieCard extends StatelessWidget {
  final String imgPath;
  final String contentUrl;
  final String contentType;

  RandomMovieCard({
    @required this.imgPath,
    @required this.contentUrl,
    @required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          if (contentUrl == null || contentUrl.isEmpty) {
            return;
          }
          AppUtils.launchURL(contentUrl ?? '');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
            width: wp(90),
            fit: BoxFit.cover,
            height: double.infinity,
            image: ExtendedNetworkImageProvider(
              imgPath,
              cache: true,
              cacheRawData: true,
              imageCacheName: imgPath,
            ),
            placeholder: AssetImage(
              ImageNames.thumbPlaceHolder,
            ),
            placeholderErrorBuilder: (context, obj, stackTrace) {
              return getImageShimmer(height: double.infinity, width: wp(90));
            },
            fadeInDuration: Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }
}

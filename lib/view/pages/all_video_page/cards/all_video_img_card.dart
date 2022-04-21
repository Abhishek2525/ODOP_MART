import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/constant/app_constant.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class AllVideoImgCard extends StatelessWidget {
  final String imgPath;
  final Function onTap;

  AllVideoImgCard({
    this.imgPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FadeInImage(
              width: wp(29),
              height: double.infinity,
              fit: BoxFit.cover,
              placeholder: AssetImage(
                ImageNames.thumbPlaceHolder,
              ),
              placeholderErrorBuilder: (context, object, stackTrae) {
                return getImageShimmer(width: wp(29), height: double.infinity);
              },
              image: ExtendedNetworkImageProvider(
                '$imgPath',
                cache: true,
                cacheRawData: true,
                imageCacheName: '$imgPath',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../core/constant/app_constant.dart';
import '../../widgets/shimmers/image_shimmer.dart';

class TVSeriesImgCard extends StatelessWidget {
  final Function onTap;
  final String imgPath;
  final seriesName;

  TVSeriesImgCard({
    this.onTap,
    this.imgPath,
    this.seriesName,
  });

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FadeInImage(
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: AssetImage(
                  ImageNames.thumbPlaceHolder,
                ),
                fadeInDuration: Duration(milliseconds: 300),
                placeholderErrorBuilder: (context, object, stackTrae) {
                  return getImageShimmer(
                      height: double.infinity, width: wp(29));
                },
                image: ExtendedNetworkImageProvider(
                  imgPath ?? 'images/card.jpg',
                  cache: true,
                  cacheRawData: true,
                  imageCacheName: imgPath ?? 'images/card.jpg',
                ),
                imageErrorBuilder: (context, object, stackTrae) {
                  return getImageShimmer(
                      height: double.infinity, width: wp(29));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                seriesName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

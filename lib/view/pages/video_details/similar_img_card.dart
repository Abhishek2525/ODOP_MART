import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../core/constant/app_constant.dart';
import '../../widgets/shimmers/image_shimmer.dart';

class SimilarImgCard extends StatelessWidget {
  final episodeNumber;
  final String imgPath;
  final Function onTap;

  SimilarImgCard({this.episodeNumber, this.imgPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              FadeInImage(
                width: wp(50),
                height: double.maxFinite,
                fit: BoxFit.cover,
                image: ExtendedNetworkImageProvider(
                  imgPath,
                  cache: true,
                  cacheRawData: true,
                  imageCacheName: imgPath,
                ),
                placeholder: AssetImage(
                  ImageNames.thumbPlaceHolder,
                ),
                fadeInDuration: Duration(milliseconds: 300),
                placeholderErrorBuilder: (context, object, stackTrae) {
                  return getImageShimmer(
                      height: double.infinity, width: wp(50));
                },
                imageErrorBuilder: (context, object, stackTrae) {
                  return getImageShimmer(
                      height: double.infinity, width: wp(50));
                },
              ),
              Visibility(
                visible: episodeNumber != null,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Episode $episodeNumber',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

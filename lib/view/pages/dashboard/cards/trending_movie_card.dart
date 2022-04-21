import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/api/app_urls.dart';
import '../../../constant/app_colors.dart';

class TrendingMovieWidget extends StatelessWidget {
  final Function onTap;
  final String imgPath;
  final int movieIndex;

  TrendingMovieWidget({
    this.onTap,
    this.imgPath,
    this.movieIndex,
  });

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: wp(29),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    imgPath != null
                        ? AppUrls.imageBaseUrl + imgPath
                        : 'images/card.JPG',
                    cache: true,
                    cacheRawData: true,
                    imageCacheName: imgPath != null
                        ? AppUrls.imageBaseUrl + imgPath
                        : 'images/card.JPG',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                    color: AppColors.shadowRed,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                child: Container(
                  child: Center(
                    child: Text(
                      '$movieIndex'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

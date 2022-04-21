import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../core/api/app_urls.dart';
import '../../constant/app_colors.dart';

class SeasonVideoCard extends StatelessWidget {
  final int index;
  final String title;
  final String imgPath;
  final Function onTap;

  SeasonVideoCard({this.index, this.title, this.onTap, this.imgPath});

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(03),
            border: Border.all(
                color: AppColors.shadowRed.withOpacity(.1), width: 1),
            boxShadow: [
              BoxShadow(
                  color: AppColors.fillBorderColor.withOpacity(.3),
                  offset: Offset(0, 2),
                  spreadRadius: .5,
                  blurRadius: .5)
            ]),
        child: Column(
          children: [
            Container(
              width: wp(50),
              height: wp(50) * (3 / 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(3),
                  topLeft: Radius.circular(3),
                ),
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    imgPath != null
                        ? AppUrls.imageBaseUrl + imgPath
                        : 'https://picsum.photos/90',
                    cache: true,
                    cacheRawData: true,
                    imageCacheName: imgPath != null
                        ? AppUrls.imageBaseUrl + imgPath
                        : 'https://picsum.photos/90',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                width: wp(50),
                alignment: Alignment.centerLeft,
                child: Text(
                  "$index. $title",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

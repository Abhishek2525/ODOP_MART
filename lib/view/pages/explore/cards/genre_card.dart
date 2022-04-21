import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';

import '../../../../core/api/app_urls.dart';
import '../../../constant/app_colors.dart';

class GenreCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  GenreCard({this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Stack(
        children: [
          Container(
            // width: wp(29),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: AppColors.yellowColor, width: 2),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.7), BlendMode.srcOver),
                image: ExtendedNetworkImageProvider(
                  AppUrls.imageBaseUrl + "$imageUrl",
                  cache: true,
                  cacheRawData: true,
                  imageCacheName: AppUrls.imageBaseUrl + "$imageUrl",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Text(
              name ?? '',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}

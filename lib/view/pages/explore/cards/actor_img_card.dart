import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/api/app_urls.dart';
import '../../../../core/constant/app_constant.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class ActorImgCard extends StatefulWidget {
  final String name;
  final String imageUrl;

  ActorImgCard({this.imageUrl, this.name});

  @override
  _ActorImgCardState createState() => _ActorImgCardState();
}

class _ActorImgCardState extends State<ActorImgCard> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                width: wp(29),
                fit: BoxFit.cover,
                image: ExtendedNetworkImageProvider(
                  AppUrls.imageBaseUrl + "${widget?.imageUrl}",
                  cache: true,
                  cacheRawData: true,
                  imageCacheName: AppUrls.imageBaseUrl + "${widget?.imageUrl}",
                ),
                placeholder: AssetImage(
                  ImageNames.thumbPlaceHolder,
                ),
                placeholderErrorBuilder: (context, obj, stackTrace) {
                  return getImageShimmer(
                      height: double.infinity, width: wp(29));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              widget?.name ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 6,
                fontWeight: FontWeight.w300,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../core/constant/app_constant.dart';
import '../../widgets/shimmers/image_shimmer.dart';

class IndividualAllSeasonCard extends StatelessWidget {
  final String title;
  final String img;
  final Function onTap;

  IndividualAllSeasonCard({this.title, this.img, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(03),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: FadeInImage(
                width: wp(29),
                height: wp(50) * (6 / 9),
                fit: BoxFit.cover,
                placeholder: AssetImage(
                  ImageNames.thumbPlaceHolder,
                ),
                fadeInDuration: Duration(milliseconds: 300),
                placeholderErrorBuilder: (context, object, stackTrae) {
                  return getImageShimmer(
                      height: wp(50) * (6 / 9), width: wp(29));
                },
                image: ExtendedNetworkImageProvider(
                  '$img',
                  cache: true,
                  cacheRawData: true,
                  imageCacheName: "$img",
                ),
                imageErrorBuilder: (context, object, stackTrae) {
                  return getImageShimmer(
                      height: double.infinity, width: wp(29));
                },
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                width: wp(50),
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme?.headline2?.color,
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

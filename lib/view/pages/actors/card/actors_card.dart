import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../../core/constant/app_constant.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class ActorsCard extends StatelessWidget {
  ActorsCard({this.name, this.imagePath, this.onTap});

  final String name;
  final String imagePath;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).appBarTheme.backgroundColor),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: ExtendedNetworkImageProvider(
                    imagePath,
                    cache: true,
                    cacheRawData: true,
                    imageCacheName: imagePath,
                  ),
                  placeholder: AssetImage(
                    ImageNames.thumbPlaceHolder,
                  ),
                  fadeInDuration: Duration(milliseconds: 300),
                  placeholderErrorBuilder: (context, object, stackTrae) {
                    return getImageShimmer(
                        height: double.infinity, width: wp(29));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 25,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 10.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

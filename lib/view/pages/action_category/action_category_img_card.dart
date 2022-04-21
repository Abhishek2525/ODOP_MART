import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../core/constant/app_constant.dart';
import '../../widgets/shimmers/image_shimmer.dart';

class ActionCategoryImgCard extends StatelessWidget {
  final String imgPath;
  final Function onTap;

  ActionCategoryImgCard({this.imgPath, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FadeInImage(
              width: wp(29),
              fit: BoxFit.cover,
              image: ExtendedNetworkImageProvider(
                imgPath ?? 'https://picsum.photos/60',
                cache: true,
                cacheRawData: true,
                imageCacheName: imgPath ?? 'https:/picsum.photos/60',
              ),
              placeholder: AssetImage(
                ImageNames.thumbPlaceHolder,
              ),
              fadeInDuration: Duration(milliseconds: 300),
              placeholderErrorBuilder: (context, object, stackTrae) {
                return getImageShimmer(height: double.infinity, width: wp(29));
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../../../../core/constant/app_constant.dart';
import '../../../../core/view_models/theme_view_model.dart';
import '../../../constant/app_colors.dart';
import '../../../widgets/shimmers/image_shimmer.dart';

class CountryCard extends StatelessWidget {
  CountryCard({
    this.countryFlagPath,
    this.countryName,
    this.onTap,
  });

  final String countryFlagPath;
  final String countryName;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: ShapeOfView(
          shape: RoundRectShape(
            borderRadius: BorderRadius.circular(10),
            borderColor: AppColors.appAmber,
            borderWidth: 2,
          ),
          elevation: 0,
          child: Stack(
            children: [
              FadeInImage(
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
                  countryFlagPath,
                  cache: true,
                  cacheRawData: true,
                  imageCacheName: countryFlagPath,
                ),
                imageErrorBuilder: (context, object, stackTrae) {
                  return getImageShimmer(
                      height: double.infinity, width: wp(29));
                },
              ),
              Container(
                child: GetBuilder<ThemeController>(
                  builder: (controller) => Container(
                    color: controller.themeMode.index == 2
                        ? Colors.black.withOpacity(0.7)
                        : Colors.white.withOpacity(0.7),
                    child: Center(
                      child: Text(
                        countryName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 15.0,
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
      ),
    );
  }
}

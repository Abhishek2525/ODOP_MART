import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:get/get.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../../../../core/view_models/theme_view_model.dart';
import '../../../constant/app_colors.dart';

class GenrePageCard extends StatelessWidget {
  GenrePageCard({this.imagePath, this.name, this.onTap});

  final String imagePath;
  final String name;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ShapeOfView(
        shape: RoundRectShape(
          borderRadius: BorderRadius.circular(10),
          borderColor: AppColors.appAmber,
          borderWidth: 2,
        ),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    imagePath,
                    cache: true,
                    cacheRawData: true,
                    imageCacheName: imagePath,
                  ),
                  fit: BoxFit.cover,
                )),
            child: GetBuilder<ThemeController>(
              builder: (controller) => Container(
                color: controller.themeMode.index == 2
                    ? Colors.black.withOpacity(0.1)
                    : Colors.white.withOpacity(0.2),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: controller.themeMode.index == 2
                            ? Colors.white
                            : Colors.black,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          //softWrap: false,
                          maxLines: 1,
                          style: TextStyle(
                            color: controller.themeMode.index == 2
                                ? Colors.black
                                : Colors.white,
                           // color: Theme.of(context).textTheme.headline1.color,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                             ),
            ),
          ),
        ),
      ),
    );
  }
}

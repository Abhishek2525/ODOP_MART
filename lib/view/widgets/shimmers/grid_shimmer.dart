import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';

/// This [Function] returns a [GridView], [Shimmer] effect
/// to use in place of loading while a list of data are retrieving from server
Widget getGridShimmer(Function wp, Function hp, {int itemCount = 2}) {
  bool darkMode = ThemeController.currentThemeIsDark;
  var baseColor = darkMode ? Colors.grey[900] : Colors.grey[100];
  var highlightColor = darkMode ? Colors.grey[800] : Colors.grey[200];

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    enabled: true,
    child: ListView.builder(
      padding: EdgeInsets.all(10),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: wp(35),
                      //width: wp(28),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: wp(35),
                      //width: wp(28),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: wp(35),
                      //width: wp(28),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: wp(35),
                      //width: wp(28),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: wp(35),
                      //width: wp(28),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: wp(35),
                      //width: wp(28),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      itemCount: itemCount,
    ),
  );
}

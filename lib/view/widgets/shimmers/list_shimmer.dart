import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';

/// This [Function] returns a [ListView], [Shimmer] effect
/// to use in place of loading while a list of data are retrieving from server
Widget getListShimmer(Function wp, Function hp, {int itemCount = 2}) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: AppColors.colorGray,
                    height: wp(18),
                    width: wp(18),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                        color: AppColors.colorGray,
                        height: wp(2),
                        width: wp(40),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                        color: AppColors.colorGray,
                        height: wp(2),
                        width: wp(20),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Container(
                        color: AppColors.colorGray,
                        height: wp(2),
                        width: wp(20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(wp(8)),
              child: Container(
                height: wp(16),
                width: wp(16),
                child: Icon(
                  Icons.play_circle_fill,
                  size: wp(8),
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      itemCount: itemCount,
    ),
  );
}

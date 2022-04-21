import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';

/// This [Function] returns a [GridView], [Shimmer] effect
/// to use in place of loading while a list of data are retrieving from server
Widget getTvSeriesShimmer(Function wp, Function hp) {
  bool darkMode = ThemeController.currentThemeIsDark;
  var baseColor = darkMode ? Colors.grey[900] : Colors.grey[100];
  var highlightColor = darkMode ? Colors.grey[800] : Colors.grey[200];

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    enabled: true,
    child: ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: hp(30),
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.colorGray,
                          height: wp(35),
                          width: wp(30),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.colorGray,
                          height: wp(35),
                          width: wp(30),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.colorGray,
                          height: wp(35),
                          width: wp(30),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.colorGray,
                          height: wp(35),
                          width: wp(30),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.colorGray,
                          height: wp(35),
                          width: wp(30),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: AppColors.colorGray,
                          height: wp(35),
                          width: wp(30),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: hp(30),
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
      itemCount: 1,
    ),
  );
}

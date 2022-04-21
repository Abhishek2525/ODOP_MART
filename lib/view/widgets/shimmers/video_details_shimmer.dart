import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../pages/tv_series_video_details/tv_series_video_details_page.dart';
import '../../pages/video_details/video_details_page.dart';

/// This [Function] returns a [Widget] with [Shimmer] effect
/// to use in place of loading while a video details [Widget] is getting ready
///
/// used in [VideoDetailsPage], [TvSeriesVideoDetailsPage]
Widget getVideoDetailsShimmer(Function wp, Function hp) {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 75,
                      width: 90,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: Container(
                            color: AppColors.colorGray,
                            height: 10,
                            width: 200,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 10,
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 10,
                            width: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 10,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 10,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 10,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 10,
                  width: 200,
                ),
              ),
              SizedBox(height: 32),
              Container(
                height: 170,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 170,
                            width: 200,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    );
                  },
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

Widget getFullVideoDetailsShimmer(Function wp, Function hp) {
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
              Container(
                color: AppColors.colorGray,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Container(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 75,
                      width: 90,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: Container(
                            color: AppColors.colorGray,
                            height: 16,
                            width: 200,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 16,
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 16,
                            width: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 16,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 16,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 16,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 16,
                  width: 200,
                ),
              ),
              SizedBox(height: 32),
              Container(
                height: 170,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) {
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 170,
                            width: 200,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    );
                  },
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

class FullVideoDetailsSHimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      body: getFullVideoDetailsShimmer(wp, hp),
    );
  }
}

Widget getOnlyVideoActionsShimmer(Function wp, Function hp) {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 75,
                      width: 90,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          child: Container(
                            color: AppColors.colorGray,
                            height: 16,
                            width: 200,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 16,
                            width: 150,
                          ),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: AppColors.colorGray,
                            height: 16,
                            width: 150,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 16,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 16,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: AppColors.colorGray,
                  height: 16,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppColors.colorGray,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      itemCount: 1,
    ),
  );
}

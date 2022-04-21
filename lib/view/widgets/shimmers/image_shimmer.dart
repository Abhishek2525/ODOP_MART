import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import '../../../core/view_models/theme_view_model.dart';

/// This [Function] returns a [Image] placeholder [Shimmer] effect
/// to use in place of loading while an [Image\] retrieving from server
Widget getImageShimmer({@required double height, @required double width}) {
  bool darkMode = ThemeController.currentThemeIsDark;
  var baseColor = darkMode ? Colors.grey[800] : Colors.grey[300];
  var highlightColor = darkMode ? Colors.grey[700] : Colors.grey[400];

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    enabled: true,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.grey,
        height: height,
        width: width,
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';

class CookiePolicy extends StatefulWidget {
  final String policyText;

  CookiePolicy({this.policyText});

  @override
  _CookiePolicyState createState() => _CookiePolicyState();
}

class _CookiePolicyState extends State<CookiePolicy> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeController.currentThemeIsDark;

    return Scaffold(
      appBar: IotaAppBar.appBarWithTitle(
          title: "Cookie Policy",
          borderColor: AppColors.deepRed,
          backButtonOnTap: () {
            AppRouter.back();
          }),
      body: SingleChildScrollView(
        child: Container(
          child: Html(
            data: widget.policyText,
            style: {
              "body": Style(
                textAlign: TextAlign.center,
                color: darkMode ? Colors.white : Colors.black,
                backgroundColor: darkMode
                    ? AppColors.darkScaffoldBackgroundColor
                    : AppColors.lightScaffoldBackgroundColor,
              ),
            },
          ),
        ),
      ),
    );
  }
}

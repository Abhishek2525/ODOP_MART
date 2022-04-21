import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';

class PrivacyPolicy extends StatefulWidget {
  final String privacyPolicyText;

  PrivacyPolicy({this.privacyPolicyText});

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool darkMode = ThemeController.currentThemeIsDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IotaAppBar.appBarWithTitle(
          title: "Privacy Policy",
          borderColor: AppColors.deepRed,
          backButtonOnTap: () {
            AppRouter.back();
          }),
      body: SingleChildScrollView(
        child: Container(
          child: Html(
            data: widget.privacyPolicyText,
            style: {
              "body": Style(
                textAlign: TextAlign.start,
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

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';

class TermsOfUsePage extends StatefulWidget {
  final String termUseText;

  TermsOfUsePage({this.termUseText});

  @override
  _TermsOfUsePageState createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeController.currentThemeIsDark;

    return Scaffold(
      appBar: IotaAppBar.appBarWithTitle(
        title: "Terms Of Use",
        borderColor: AppColors.deepRed,
        backButtonOnTap: () {
          AppRouter.back();
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Html(
            data: widget.termUseText,
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

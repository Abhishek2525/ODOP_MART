import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../base_screen.dart';

class ProfileWithoutLogIn extends StatefulWidget {
  final int nestedId;

  ProfileWithoutLogIn({this.nestedId});

  @override
  _ProfileWithoutLogInState createState() => _ProfileWithoutLogInState();
}

class _ProfileWithoutLogInState extends BaseScreen<ProfileWithoutLogIn> {
  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    final Function hp = Screen(MediaQuery.of(context).size).hp;
    return GetBuilder<ThemeController>(builder: (themeController) {
      var containerColor;
      if (themeController.themeMode == ThemeMode.dark) {
        containerColor = Theme.of(context).appBarTheme.backgroundColor;
      } else {
        containerColor = Colors.blue[50];
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: containerColor,
                height: hp(35),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(wp(10)),
                      child: Image.asset(
                        'images/noProfile.png',
                        height: wp(20),
                        width: wp(20),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          AppRouter.navToSignInPage();
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: AppColors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.deepRed,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: wp(20)),
                  child: SvgPicture.asset(
                    'assets/images/sign_in_image.svg',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}

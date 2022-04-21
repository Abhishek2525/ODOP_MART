import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';

import '../../../core/utils/local_auth/local_auth_get_storage.dart';
import '../../../core/utils/log/log.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';

/// Splash Screen of this project
///
/// Shows a splash screen for App branding
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  Animation<double> animation;
  AnimationController controller;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    controller?.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween<double>(begin: 0, end: 70).animate(controller)
      ..addStatusListener(
        (state) {
          print('$state');
          if (state == AnimationStatus.completed) {
            String token = LocalDBUtils.getJWTToken();
            Log.log("bearer_token :-  $token");
            if (token == null) {
              AppRouter.navToSignInPage();
            } else {
              AppRouter.navToHomePage();
            }
          }
        },
      );

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
          //  color: Color(0xff1D1D27).withOpacity(0.5),
          ),
          child: Align(
            alignment: Alignment(0, 0.8),
            child: Container(
              child: AnimatedBuilder(
                animation: animation,
                builder: (_, child) => Container(
                  height: 2,
                  width: wp(70),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 2,
                      width: wp(animation.value),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

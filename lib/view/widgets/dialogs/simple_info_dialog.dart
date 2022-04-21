import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../constant/app_colors.dart';

/// This [Function] shows a simple [AlertDialog] to show any kinda message or information  to user
void showSimpleInfoDialog(
    {@required String message, @required Function onLoginPresed}) {
  Get.defaultDialog(
    backgroundColor: AppColors.darkScaffoldBackgroundColor,
    radius: 10,
    title: 'Attention',
    middleText: message,
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.red),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text(
              'Log in',
              style: TextStyle(color: AppColors.red),
            ),
            onPressed: onLoginPresed,
          ),
        ],
      ),
    ],
  );
}

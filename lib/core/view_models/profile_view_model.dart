import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../view/constant/app_colors.dart';
import '../../view/pages/profile_with_login/profile_with_login.dart';
import '../../view/pages/profile_without_login/profile_without_login.dart';
import '../../view/router/app_router.dart';
import '../models/logout_model.dart';
import '../models/profile_model.dart';
import '../models/update_user_profile_model.dart';
import '../utils/local_auth/local_auth_get_storage.dart';
import 'theme_view_model.dart';

/// A [GetxController]
///
/// for managing state and separating logical codes from UI
/// of [ProfileWithLogIn] and [ProfileWithoutLogIn] Pages
class ProfileViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  /// This method perform Logout operation for user
  ///
  /// At first it shows a [Dialog] whether user really want to logout? or not.
  /// Then perform logout operation based on user permission
  void getLogoutMethod() async {
    bool isDarkModeOn = ThemeController.currentThemeIsDark;
    Get.dialog(
      AlertDialog(
        backgroundColor: isDarkModeOn
            ? AppColors.lightScaffoldBackgroundColor
            : AppColors.darkScaffoldBackgroundColor,
        title: Text(
          'Attention',
          style: TextStyle(
              color: isDarkModeOn ? AppColors.black : AppColors.white),
        ),
        content: Text(
          'Are you sure? want to logout?',
          style: TextStyle(
              color: isDarkModeOn ? AppColors.black : AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'No',
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (LocalDBUtils.getJWTToken() != null) {
                LogoutModel temp = LogoutModel();
                await temp?.callApi();
                logoutModel = temp;
                /// delete the jwt tocken
                LocalDBUtils.deleteJWTToken();
                /// delete user all information
                LocalDBUtils.deleteUserInfo();
                /// delete user premium information
                LocalDBUtils.deletePackageInformation();
                AppRouter.navToSignInPage();
                update();
                Get.back();
              }
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  LogoutModel logoutModel = LogoutModel();

  /// This method call an API to get [UserProle] from network
  void getUserProfileMethod() async {
    ProfileModel tempModel = ProfileModel();
    await tempModel?.callApi();
    profileModel = tempModel;
    update();
  }

  ProfileModel profileModel = ProfileModel();

  /// This method responsible for updating [UserProfile]
  ///
  /// Its call an api from [UpdateUserProfileModel] and update User Profile
  getUpdateUserProfileMethod({
    String name,
    String phone,
    String oldPassword,
    String password,
    File img,
  }) async {
    await updateProfileViewModel.callApi(
      name: name,
      password: password,
      phone: phone,
      oldPassword: oldPassword,
      img: img,
    );
    getUserProfileMethod();

    update();
  }

  UpdateUserProfileModel updateProfileViewModel = UpdateUserProfileModel();
}

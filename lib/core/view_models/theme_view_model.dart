import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  A [GetxController] to controller theme
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  SharedPreferences prefs;
  ThemeMode _themeMode;

  static bool currentThemeIsDark = true;

  ThemeMode get themeMode => _themeMode;

  /// This method helps to switch between themes
  Future<void> setThemeMode(ThemeMode themeMode) async {
    print("setThemeMode");
    Get.changeThemeMode(themeMode);
    _themeMode = themeMode;
    currentThemeIsDark = (themeMode?.index == 2);
    update();
    prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeMode.toString().split('.')[1]);
  }

  /// This method return The ThemeMode from shared preference
  getThemeModeFromPreferences() async {
    ThemeMode themeMode;
    prefs = await SharedPreferences.getInstance();
    String themeText = prefs.getString('theme') ?? 'dark';
    print(themeText);
    try {
      themeMode =
          ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    currentThemeIsDark = (themeMode?.index == 2);
    setThemeMode(themeMode);
  }
}

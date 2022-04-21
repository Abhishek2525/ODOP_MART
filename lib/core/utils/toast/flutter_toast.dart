import 'package:flutter/material.dart';

import 'package:toast/toast.dart';

/// Provide Toast widgets to use throughout the application
class FlutterToast {
  /// Show A simple toast
  static void show({String message, BuildContext context}) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }

  /// Show a Error Text with custom colors
  static void showErrorToast({
    String message,
    BuildContext context,
    int gravity = 0,
  }) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Show success toast with custom colors
  static void showSuccess({String message, BuildContext context}) {
    Toast.show(
      message,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}

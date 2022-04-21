import 'package:get/get.dart';

/// An Utility class to provide some form validation utility methods
class AppValidTor {
  /// this method used for validating a valid email
  static String isEmail(String s) =>
      GetUtils.isEmail(s) ? null : "Please enter a valid email";

  /// This method used for validating a string as empty or not
  static String isEmpty(String s) =>
      GetUtils.isNullOrBlank(s) ? "this field required!" : null;

  /// this method used for validating a valid password
  static String isPassword(String s) {
    if (s.isBlank || s.isEmpty) return "this field required!";
    return GetUtils.isLengthLessThan(s, 8) ? "min password length is 8" : null;
  }

  /// This method take two parameter as argument and check whether they are similar to each other
  static String isConfirmedPassword(String s, String password) {
    return s != password ? "both password not matched" : null;
  }

  /// This method check a password length is sufficient or not
  static String isMobile(String s) {
    if (s.isBlank || s.isEmpty) return "this field required!";
    return GetUtils.isLengthLessThan(s, 8) ? "min password length is 8" : null;
  }
}

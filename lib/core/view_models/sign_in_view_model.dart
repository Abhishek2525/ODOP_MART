import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../view/pages/home/homepage.dart';
import '../../view/pages/signin_page/Sign_In_Page.dart';
import '../../view/router/app_router.dart';
import '../../view/widgets/dialogs/progress_dialog.dart';
import '../models/sign_in_user_model.dart';
import '../utils/local_auth/local_auth_get_storage.dart';
import '../utils/log/log.dart';
import 'register_user_view_model.dart';

/// A [GetxController] designed for managing state
/// and performing logical operation on [SignInPage]
class SignInViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  /// This method performs sign in operation
  signInMethod({
    String email,
    String password,
    String loginMethod,
  }) async {
    Get.to(ProgressDialog(), opaque: false);

    await signInModel.callApi(
        email: email, password: password, loginMethod: loginMethod);

    Get.back();

    update();

    if (signInModel?.data?.bearerToken != null) {
      LocalDBUtils.saveJWTToken(signInModel?.data?.bearerToken);
      LocalDBUtils.saveUserInfo({
        'id': signInModel?.data?.id.toString(),
        'name': signInModel?.data?.name,
        'email': signInModel?.data?.email,
      });
      LocalDBUtils.saveActivePackageId(signInModel?.data?.activePackage ?? -1);
      Log.log("getJWTToken:-  ${LocalDBUtils.getJWTToken()}");
      AppRouter.navToHomePage(fragment: HomePageFragment.dashboard);
    } else {
      errorMsg.value = signInModel?.msg?.toString() ?? "";
    }
  }

  /// This method perform sign in operation using social media
  /// Specially Google Signin or Facebbok signin based on [loginMethod]
  socialSignIn(
      {String email, String socialId, String name, String loginMethod}) async {
    /// at first try to login
    Get.to(ProgressDialog(), opaque: false);

    await signInModel.callApi(
        email: email, password: '', loginMethod: loginMethod);

    if (signInModel.status == true) {
      if (signInModel?.data?.bearerToken != null) {
        LocalDBUtils.saveJWTToken(signInModel?.data?.bearerToken);
        LocalDBUtils.saveUserInfo({
          'id': signInModel?.data?.id.toString(),
          'name': signInModel?.data?.name,
          'email': signInModel?.data?.email,
        });
        LocalDBUtils.saveActivePackageId(signInModel?.data?.activePackage ?? -1);
        Log.log("getJWTToken:-  ${LocalDBUtils.getJWTToken()}");
        AppRouter.navToHomePage(fragment: HomePageFragment.dashboard);
      } else {
        errorMsg.value = signInModel?.msg?.toString() ?? "";
      }
    } else {
      RegisterUserViewModel registerViewModel =
          Get.put(RegisterUserViewModel());
      registerViewModel.registerUserMethod(
          email: email,
          fbOrGoogleId: socialId,
          name: name,
          registerMethod: loginMethod);
      if (registerViewModel.registerUserModel.status == true) {
        /// if user registration successful then try to log in
        await signInModel.callApi(
            email: email, password: '', loginMethod: loginMethod);
        if (signInModel?.data?.bearerToken != null) {
          LocalDBUtils.saveJWTToken(signInModel?.data?.bearerToken);
          LocalDBUtils.saveUserInfo({
            'id': signInModel?.data?.id.toString(),
            'name': signInModel?.data?.name,
            'email': signInModel?.data?.email,
          });
          LocalDBUtils.saveActivePackageId(signInModel?.data?.activePackage ?? -1);
          Log.log("getJWTToken:-  ${LocalDBUtils.getJWTToken()}");
          AppRouter.navToHomePage(fragment: HomePageFragment.dashboard);
        } else {
          errorMsg.value = signInModel?.msg?.toString() ?? "";
        }
      }
    }

    Get.back();
    update();
  }

  RxString errorMsg = ''.obs;
  SignInModel signInModel = SignInModel();

  /// This method perform google sign in operation
  /// and provide user credential associate with corresponding email
  void googleSIgin() async {
    SignInViewModel signInViewModel = Get.put(SignInViewModel());

    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

      GoogleSignInAccount account = await _googleSignIn.signIn();

      /// perform sign in or sign up operation in our server
      signInViewModel?.socialSignIn(
        email: account.email,
        name: account.displayName,
        socialId: account.id,
        loginMethod: 'google',
      );
    } catch (error) {
      print(error);
    }
  }

  /// This method perform Facebook sign in operation
  /// and provide user credential associated with corresponding Facebook account
  void fbSignIn() async {
    try {
      FacebookLogin facebookLogin = FacebookLogin();
      var result = await facebookLogin.logIn(['email', 'public_profile']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          String token = result.accessToken.token;
          String url =
              'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token';
          final response = await http.get(Uri.parse(url));
          final Map<String, dynamic> profile = jsonDecode(response.body);

          /// after getting credentials from facebook now try to signin or sign up to our server
          if (profile != null) {
            if (profile.containsKey('email')) {
              SignInViewModel signInViewModel = Get.put(SignInViewModel());
              signInViewModel?.socialSignIn(
                email: profile['email'],
                name: profile['name'],
                socialId: profile['id'],
                loginMethod: 'fb',
              );
            } else {
              Get.rawSnackbar(
                  message:
                      'Your account has no permission to read your email.');
            }
          } else {
            Get.rawSnackbar(message: 'Facebook sign in failed. Try again.');
          }
          break;

        case FacebookLoginStatus.error:
          Get.rawSnackbar(message: 'Error while sign in. Please try again.');
          break;

        case FacebookLoginStatus.cancelledByUser:
          Get.rawSnackbar(message: 'Sign in canceled.');
          break;
      }
    } catch (error) {
      print('facebook login exception = $error');
    }
  }
}

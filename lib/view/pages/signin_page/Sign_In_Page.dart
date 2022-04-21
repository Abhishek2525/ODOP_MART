import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iotflixcinema/core/view_models/settings_view_model.dart';
import 'package:uni_links/uni_links.dart';

import '../../../core/controllers/deep_linking_controller.dart';
import '../../../core/models/home_categories_model.dart';
import '../../../core/repo/deep_link_repo/deep_link_repo.dart';
import '../../../core/validetor/app_validetor.dart';
import '../../../core/view_models/sign_in_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../router/app_router.dart';
import '../../widgets/dialogs/progress_dialog.dart';
import '../../widgets/round_border_button.dart';
import '../home/homepage.dart';

///import "package:flutter_facebook_auth/flutter_facebook_auth.dart";

/// This top level property is used to configure Password TextField
bool _passwordVisible = false;

/// Provide Sign in Functionality
///
/// Allow user to signin to app and act as an authenticated user
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
    signController.errorMsg = "".obs;

    _passwordVisible = false;

    /// if user enter from deep linking then send user to video details page
    /// to see the video
    if (DeepLinkingController.deepLinkingPerformed == false) {
      DeepLinkingController.deepLinkingPerformed = true;
      Future.delayed(Duration(seconds: 2)).then((value) {
        initUniLinks();
      });
    }
  }

  void dispose() {
    /// dispose all controllers to avoid memory leak
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Form Key
  ///
  /// allow to work with Text Input [Form]
  /// * save current state
  /// * validate form
  /// * show error message
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  bool obscureText = true;

  SignInViewModel signController = Get.put(SignInViewModel());

  /// Handle Deep Linking
  ///
  /// This method detect if a user enter in app by clicking any link that
  /// has been shared withing this app by any other user.
  ///
  /// If user enter to this app by clicking deep link then this method
  /// detect the event and do specific work according to event
  Future<void> initUniLinks() async {
    try {
      final initialLink = await getInitialLink();

      if (initialLink != null && initialLink.isNotEmpty) {
        List<String> lst = initialLink.split('/');
        String id = lst[lst.length - 1];
        Get.to(ProgressDialog(message: 'Video is loading...'), opaque: false);
        HomeData homeData = await DeepLinkRepo().getVideoFromDeepLink(id);
        Get.back();
        if (homeData != null) {
          AppRouter.navToVideoDetailsPage(homeData, 0, homeData.categoryId);
        }
      }
    } on PlatformException {}
  }

  /// This method unfocus all focused widgets
  void allUnFocus() {
    emailNode.unfocus();
    passwordNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GetBuilder<ThemeController>(
        builder: (controller) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                controller.themeMode?.index == 2
                    ? "images/background1.jpg"
                    : "images/background1.jpg",
                // ? "images/background1.png"
                // : "assets/images/splash/light_splash.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10.0, right: 20.0),
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        AppRouter.navToHomePage(
                            fragment: HomePageFragment.dashboard);
                      },
                      child: Text(
                        "SKIP",
                        style: TextStyle(
                            color: Color(0xFFE15050),
                            fontSize: 18,
                            fontFamily: 'poppins_bold'),
                      ),
                    ),
                  ),
                  // Spacer(),
                  // Text('data', style: TextStyle(color: Colors.red),),
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                 Image.asset("images/BharatSamanway.png", width: MediaQuery.of(context).size.width*0.4,),
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                  Column(
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage("images/shadebackground.png"),
                              fit: BoxFit.fill,
                            )),
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 30.0, right: 5.0, left: 5.0),
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          color: Colors.white,
                                          //Color(0xFFEDEDED),
                                          border: Border.all(
                                            color: Color(0xffF0F0F0),
                                            width: 2.0,
                                            style: BorderStyle.solid,
                                          )),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        focusNode: emailNode,
                                        onFieldSubmitted: (v) {
                                          emailNode.unfocus();
                                          passwordNode.requestFocus();
                                        },
                                        validator: (value) =>
                                            AppValidTor.isEmail(value),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontFamily: 'poppins_semibold'),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: 'poppins_semibold'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                      child: Divider(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Color(0xffF0F0F0),
                                            width: 2.0,
                                            style: BorderStyle.solid,
                                          )),
                                      child: TextFormField(
                                        obscureText: !_passwordVisible,
                                        controller: passwordController,
                                        focusNode: passwordNode,
                                        onFieldSubmitted: (v) {
                                          passwordNode.unfocus();
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (value) =>
                                            AppValidTor.isPassword(value),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontFamily: 'poppins_semibold'),
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              // Based on passwordVisible state choose the icon
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              size: 15.0,
                                              color: Theme.of(context)
                                                  .copyWith(
                                                      primaryColor:
                                                          Color(0xFFE15050))
                                                  .primaryColor,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          ),
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black,
                                              fontFamily: 'poppins_semibold'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              GetBuilder<SignInViewModel>(
                                builder: (controller) => RoundBoarderButton(
                                    padding: 10.0,
                                    text: "LOGIN",
                                    onPress: () {
                                      allUnFocus();
                                      if (_formKey.currentState.validate()) {
                                        controller?.signInMethod(
                                          email: emailController?.text?.trim(),
                                          password:
                                              passwordController?.text?.trim(),
                                          loginMethod: 'normal',
                                        );
                                      }
                                    }),
                              ),
                              GetX<SignInViewModel>(
                                builder: (controller) => Center(
                                  child: Visibility(
                                    visible: controller?.errorMsg?.value != "",
                                    child: Text(
                                      controller?.errorMsg?.value ?? "",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xffe11d74),
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .color,
                                        fontFamily: "poppins_medium",
                                        fontSize: 14.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   child: Center(
                              //     child: Text(
                              //       "or login with",
                              //       style: TextStyle(
                              //           color: Theme.of(context)
                              //               .textTheme
                              //               .headline1
                              //               .color,
                              //           fontFamily: "poppins_medium",
                              //           fontSize: 16.0),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20.0,
                              // ),
                              // Container(
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       InkWell(
                              //         onTap: () {
                              //           signController.fbSignIn();
                              //         },
                              //         child: Container(
                              //           height: 50,
                              //           width: 50,
                              //           decoration: BoxDecoration(
                              //             borderRadius:
                              //                 BorderRadius.circular(10.0),
                              //             color: Colors.white,
                              //           ),
                              //           child: Icon(
                              //             FontAwesomeIcons.facebookF,
                              //             color: Colors.red,
                              //           ),
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: 20.0,
                              //       ),
                              //       InkWell(
                              //         onTap: () {
                              //           signController.googleSIgin();
                              //         },
                              //         child: Container(
                              //             height: 50,
                              //             width: 50,
                              //             decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(10.0),
                              //               color: Colors.white,
                              //             ),
                              //             child: Icon(
                              //               FontAwesomeIcons.google,
                              //               color: Colors.red,
                              //             )),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Became a member? ",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .color,
                                        fontSize: 14.0,
                                        fontFamily: 'poppins_medium'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      AppRouter.navToSignUpPage();
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFFE15050),
                                          fontSize: 14.0,
                                          fontFamily: 'poppins_medium'),
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "By proceeding, you agree to our ",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .color,
                                        fontSize: 12.0,
                                        fontFamily: 'poppins_medium'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SettingsViewModel vm = Get.find();
                                      String terms = vm.settingsModel?.data?.termsCondition ?? '';
                                      if(terms.isNotEmpty){
                                        AppRouter.navToTermsOfUsePage(termUseText: terms);
                                      }
                                    },
                                    child: Text(
                                      "Term of Use",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFFE15050),
                                          fontSize: 12.0,
                                          fontFamily: 'poppins_medium'),
                                    ),
                                  ),
                                ],
                              )),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "\& ",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .color,
                                        fontSize: 12.0,
                                        fontFamily: 'poppins_medium'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SettingsViewModel vm = Get.find();
                                      String privacy = vm.settingsModel?.data?.privacyPolicy ?? '';
                                      if(privacy.isNotEmpty){
                                        AppRouter.navToPrivacyPolicy(privacyPolicyText: privacy);
                                      }
                                    },
                                    child: Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xFFE15050),
                                          fontSize: 12.0,
                                          fontFamily: 'poppins_medium'),
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(
                                height: 20.0,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

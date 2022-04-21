import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../view/constant/app_colors.dart';
import '../../view/pages/signin_page/Sign_In_Page.dart';
import '../../view/pages/subcribe/pay_pal_payment_webview_page.dart';
import '../../view/widgets/dialogs/progress_dialog.dart';
import '../../view/widgets/dialogs/simple_info_dialog.dart';
import '../models/subscription_package.dart';
import '../repo/subscription_repo/subscription_repo.dart';
import '../utils/local_auth/local_auth_get_storage.dart';

class SubscriptionPaymentViewModel extends GetxController {
  SubscriptionRepo repo = SubscriptionRepo();

  RxString paymentType = ''.obs;

  RxList<SubscriptionPackage> packageList = <SubscriptionPackage>[].obs;
  RxBool packagesLoading = false.obs;

  @override
  void onInit() {
    getPackageList();

    super.onInit();
  }

  void getPackageList() async {
    packagesLoading.value = true;
    packageList.value = await repo.getAllPackageList();
    packagesLoading.value = false;
  }

  void getPaypalRedirectUrl(String amount) async {
    Get.to(ProgressDialog(
      message: 'Preparing your payment...',
    ));
    String paymentMethodUrl = await repo.getPaypalRedirectUrl(amount);
    Get.back();
    if (paymentMethodUrl == null || paymentMethodUrl.isEmpty) {
      showDialog(
        message: 'Error while preparing your payment environment. Try again.',
        onPressed: () {
          Get.back();
        },
      );
    } else {
      Get.to(PaypalPaymentWebViewPage(paymentMethodUrl),
          transition: Transition.cupertino);
    }
  }

  void postStripePayment({
    @required String cardNumber,
    @required String cvcNumber,
    @required String expMonth,
    @required String expYear,
    @required String packageId,
    @required String totalPrice,
  }) async {
    String token = LocalDBUtils.getJWTToken();

    if (token == null || token.isEmpty) {
      _handleUnAuthenticatedUserActivity();
      return;
    }

    Map<String, dynamic> userInfoMap = LocalDBUtils.getUserInfo();

    final header = {'Authorization': 'Bearer $token'};

    Map<String, String> body = {};
    body['number'] = '$cardNumber';
    body['expire_month'] = '$expMonth';
    body['exp_year'] = '$expYear';
    body['cvc'] = '$cvcNumber';
    body['amount'] = '$totalPrice';
    body['user_id'] = '${userInfoMap['id']}';
    body['email'] = '${userInfoMap['email']}';

    Get.to(
        ProgressDialog(
          message: 'Your payment in progress...',
        ),
        opaque: false);
    bool result = await repo.postStripePayment(body, header);
    Get.back();

    _interactWithResult(result);
  }

  void _handleUnAuthenticatedUserActivity() {
    showSimpleInfoDialog(
      message: 'You are not Logged in, Please login and try again.',
      onLoginPresed: () {
        Get.offAll(SignInPage(), transition: Transition.cupertino);
      },
    );
  }

  void _interactWithResult(bool result) {
    if (result == true) {
      showDialog(
        message: 'Success!. Enjoy your premium feel.',
        onPressed: () {
          Get.back();
          Get.back();
        },
      );
    } else {
      showDialog(
        message: 'Failed, Give valid information and try again',
        onPressed: () {
          Get.back();
        },
      );
    }
  }

  void showDialog({@required String message, @required Function onPressed}) {
    Get.defaultDialog(
      barrierDismissible: false,
      backgroundColor: AppColors.darkScaffoldBackgroundColor,
      contentPadding: EdgeInsets.all(16),
      radius: 10,
      title: 'Attention',
      middleText: '$message',
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(color: AppColors.red),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ],
    );
  }

  String getCardNumberFromFormattedString(String number, String separator) {
    String result = '';
    for (int i = 0; i < number.length; i++) {
      if (number[i] != separator) {
        result += number[i];
      }
    }
    return result;
  }
}

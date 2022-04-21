import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/models/subscription_package.dart';
import '../../../core/view_models/subscription_payment_viewmodel.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import 'card/subscription_packes_view.dart';

class SubScribePage extends StatefulWidget {
  @override
  _SubScribePageState createState() => _SubScribePageState();
}

class _SubScribePageState extends State<SubScribePage> {
  PageController controller = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  SubscriptionPaymentViewModel _viewModel =
      Get.put(SubscriptionPaymentViewModel());

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      appBar: IotaAppBar.appBarWithTitle(
          title: "Subscribe",
          backButtonOnTap: () {
            AppRouter.back();
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: wp(100),
                child: Center(
                  child: Text(
                    "Choose any plan. Its 50% off\nyour first 2 months",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontSize: 18.0,
                      fontFamily: 'poppins_medium',
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: wp(100),
                child: Center(
                  child: Text(
                    "Downgrade or upgrade\nat any time",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.shadowRed,
                      fontSize: 16.0,
                      fontFamily: 'poppins_regular',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() {
                if (_viewModel.packagesLoading.value) {
                  return Container(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.red,
                      ),
                    ),
                  );
                }

                List<SubscriptionPackage> packageList =
                    // ignore: invalid_use_of_protected_member
                    _viewModel.packageList.value;

                return Container(
                  height: 560,
                  child: PageView(
                    controller: controller,
                    children: [
                      for (SubscriptionPackage pack in packageList)
                        SubScripTonPlanView(pack),
                    ],
                  ),
                );
              }),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

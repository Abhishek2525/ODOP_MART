import 'package:flutter/material.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iotflixcinema/core/models/subscription_package.dart';
import 'package:iotflixcinema/core/utils/local_auth/local_auth_get_storage.dart';
import 'package:iotflixcinema/core/view_models/subscription_payment_viewmodel.dart';
import 'package:iotflixcinema/view/constant/app_colors.dart';
import 'package:iotflixcinema/view/pages/signin_page/Sign_In_Page.dart';
import 'package:iotflixcinema/view/pages/subcribe/subscription_payment_method_page.dart';
import 'package:iotflixcinema/view/widgets/dialogs/simple_info_dialog.dart';

class PremiumVideoWarningPage extends StatefulWidget {
  @override
  _PremiumVideoWarningPageState createState() =>
      _PremiumVideoWarningPageState();
}

class _PremiumVideoWarningPageState extends State<PremiumVideoWarningPage> {
  SubscriptionPaymentViewModel _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Need Premium\nSubscription',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline2.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SvgPicture.asset(
                    'assets/svg/premium_warning_ic.svg',
                    height: wp(30),
                    width: wp(30),
                  ),
                ),
                Text(
                  '''Unlock all video's''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline2.color,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Text(
                  '''Recurring billing, Cancel anytime, Payment will be\nchanged on your account to purchase. Your\nsubscription automatically renews unless auto\nrenew is turned off.''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline2.color,
                  ),
                ),

                /// return premium package list
                Obx(() {
                  if (_controller.packagesLoading.value) {
                    return CircularProgressIndicator();
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 32, horizontal: wp(10)),
                      child: ListView.builder(
                        itemCount: _controller.packageList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          SubscriptionPackage package =
                              _controller.packageList[index];
                          return InkWell(
                            onTap: () {
                              String token = LocalDBUtils.getJWTToken();

                              if (token == null) {
                                showSimpleInfoDialog(
                                  message: 'To buy any premium package you need to login to our app first.',
                                  onLoginPresed: () {
                                    Get.to(SignInPage());
                                  },
                                );
                              } else {
                                Get.to(SubscriptionPaymentMethodPage(package));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 2,
                                  color: AppColors.deepRed,
                                ),
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        package?.name ?? '',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .color,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${package?.price ?? 0}',
                                          style: TextStyle(
                                            color: AppColors.deepRed,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '/${package.duration ?? 0} d',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  'Downgrade or upgrade at any time',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .color,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

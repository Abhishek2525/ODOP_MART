import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/models/subscription_package.dart';
import '../../../core/utils/text_field_formatter/masked_text_input_formatter.dart';
import '../../../core/view_models/subscription_payment_viewmodel.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../constant/app_colors.dart';

// ignore: must_be_immutable
class SubscriptionPaymentMethodPage extends StatefulWidget {
  SubscriptionPackage package;

  SubscriptionPaymentMethodPage(this.package);

  @override
  _SubscriptionPaymentMethodPageState createState() =>
      _SubscriptionPaymentMethodPageState();
}

class _SubscriptionPaymentMethodPageState
    extends State<SubscriptionPaymentMethodPage> {
  SubscriptionPaymentViewModel _viewModel =
      Get.put(SubscriptionPaymentViewModel());

  FocusNode numberNode = FocusNode();
  FocusNode cvcNode = FocusNode();

  final _stripeFormKey = GlobalKey<FormState>();

  String stripeCardNumber = '';
  String stripeCvcNumber = '';

  String separator = ' ';

  Color iconColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;

    return GetBuilder<ThemeController>(
      builder: (controller) {
        return Obx(() {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(wp(6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment methods',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                        ),
                      ),
                      SizedBox(
                        height: hp(10),
                      ),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ListTile(
                                title: Text(
                                  'PayPal',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                  ),
                                ),
                                leading: Radio<String>(
                                  value: 'paypal',
                                  groupValue: _viewModel.paymentType.value,
                                  onChanged: (value) {
                                    _viewModel.paymentType.value = value;
                                  },
                                ),
                                trailing: Image.asset(
                                    'assets/images/payment/paypal.png'),
                              ),
                              ListTile(
                                title: Text(
                                  'Card',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                  ),
                                ),
                                leading: Radio<String>(
                                  value: 'stripe',
                                  groupValue: _viewModel.paymentType.value,
                                  onChanged: (value) {
                                    _viewModel.paymentType.value = value;
                                  },
                                ),
                                trailing: Image.asset(
                                    'assets/images/payment/master.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: hp(10),
                      ),

                      /// pay pal input form
                      Visibility(
                        visible: _viewModel.paymentType.value == 'paypal',
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(wp(4)),
                            child: Column(
                              children: [
                                Card(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 50,
                                    width: wp(80),
                                    child: InkWell(
                                      onTap: () {
                                        _viewModel.getPaypalRedirectUrl(
                                            widget.package?.price?.toString() ??
                                                '10');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.shadowRed,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Continue",
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14.0,
                                              fontFamily: 'poppins_bold',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// card input form
                      Visibility(
                        visible: _viewModel.paymentType.value == 'stripe',
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(wp(4)),
                            child: Form(
                              key: _stripeFormKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Stripe Payment info',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .color,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 32),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.credit_card,
                                          color: iconColor,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          'Card Number',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// card number text field
                                  TextFormField(
                                    focusNode: numberNode,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MaskedTextInputFormatter(
                                          mask: 'XXXX XXXX XXXX XXXX',
                                          separator: separator),
                                    ],
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: 'XXXX XXXX XXXX XXXX',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'Enter your card number';
                                      } else if (val.length < 16) {
                                        return 'Enter a valid card number';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      stripeCardNumber = val;
                                    },
                                    onChanged: (val) {},
                                  ),

                                  SizedBox(
                                    height: 32,
                                  ),

                                  /// expire date and cvc
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.security,
                                                    color: iconColor,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'Expire Date:  MM/YYYY',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .headline1
                                                          .color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                height: 50,
                                                width: double.maxFinite,
                                                color: Colors.grey.shade100,
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Text(
                                                  getExpireDate(),
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.security,
                                                    color: iconColor,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'CVC',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .headline1
                                                          .color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// cvc text field
                                            TextFormField(
                                              focusNode: cvcNode,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              inputFormatters: [
                                                MaskedTextInputFormatter(
                                                    mask: 'XXXX',
                                                    separator: ''),
                                              ],
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                hintText: 'XXXX',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                fillColor: Colors.grey.shade100,
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                              validator: (val) {
                                                if (val.isEmpty) {
                                                  return 'Enter CVC number';
                                                }
                                                return null;
                                              },
                                              onSaved: (val) {
                                                stripeCvcNumber = val;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 32,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total amount: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .color,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        '${widget.package.price}\$',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .color,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 32,
                                  ),

                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 50,
                                    width: wp(80),
                                    child: InkWell(
                                      onTap: () {
                                        String packageId =
                                            widget.package?.id?.toString();
                                        String packagePrice =
                                            widget.package.price.toString();
                                        String expMonth =
                                            getExpireDate().split('/')[0];
                                        String expYear =
                                            getExpireDate().split('/')[1];

                                        if (_stripeFormKey.currentState
                                            .validate()) {
                                          _stripeFormKey.currentState.save();

                                          print(
                                              'card number = ${_viewModel.getCardNumberFromFormattedString(stripeCardNumber, separator)}');

                                          _viewModel.postStripePayment(
                                            packageId: packageId,
                                            cardNumber: _viewModel
                                                .getCardNumberFromFormattedString(
                                                    stripeCardNumber,
                                                    separator),
                                            cvcNumber: stripeCvcNumber,
                                            expMonth: expMonth,
                                            expYear: expYear,
                                            totalPrice: packagePrice,
                                          );
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.shadowRed,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Pay & Buy",
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 14.0,
                                              fontFamily: 'poppins_bold',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  String getExpireDate() {
    var date = DateTime.now();
    int month = date.month;
    int year = date.year;

    if (month == 12) {
      month = 1;
      year++;
    }

    return '$month/$year';
  }
}

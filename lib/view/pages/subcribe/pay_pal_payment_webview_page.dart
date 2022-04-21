import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../core/view_models/subscription_payment_viewmodel.dart';

// ignore: must_be_immutable
class PaypalPaymentWebViewPage extends StatefulWidget {
  String initialUrl;

  PaypalPaymentWebViewPage(this.initialUrl);

  @override
  _PaypalPaymentWebViewPageState createState() =>
      _PaypalPaymentWebViewPageState();
}

class _PaypalPaymentWebViewPageState extends State<PaypalPaymentWebViewPage> {
  SubscriptionPaymentViewModel _viewModel = Get.find();

  final String successUrl =
      '/videoapp/api/paypal/success'; //'${AppUrls.baseUrl}api/paypal/success';
  final String failUrl = '/videoapp/api/paypal/fail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Share',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              fontFamily: 'poppins_medium'),
        ),
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            child: ImageIcon(
              AssetImage('images/backIcon.png'),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SelectableText('sb-hinui7537027@personal.example.com'),
          SelectableText(';u0Zd=CT'),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.initialUrl)),
              onLoadStart: (controller, uri) {
                if (successUrl.contains(uri.path)) {
                  Get.back();
                  _viewModel.showDialog(
                    message: 'Success!. Enjoy your premium feeling.',
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                  );
                  return;
                }

                if (failUrl.contains(uri.path)) {
                  Get.back();
                  _viewModel.showDialog(
                    message: 'Payment failed, Try again',
                    onPressed: () {
                      Get.back();
                    },
                  );
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../api/app_urls.dart';
import '../../models/subscription_package.dart';

class SubscriptionRepo {
  String getAllPackagesUrl = 'https://bs.tech/videoapp/api/get/package';

  Future<List<SubscriptionPackage>> getAllPackageList() async {
    try {
      List<SubscriptionPackage> packList = [];

      Uri url = Uri.parse(getAllPackagesUrl);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        for (var json in resBody['data']) {
          packList.add(SubscriptionPackage.fromJson(json));
        }

        return packList;
      }
    } catch (err) {
      print('$err');
    }

    return [];
  }

  Future<bool> postStripePayment(
      Map<String, String> body, Map<String, String> headers) async {
    try {
      String url = AppUrls.stripePaymentUrl;
      final response =
          await http.post(Uri.parse(url), body: body, headers: headers);
      print('request body = $body');
      print('request headers = $headers');
      print('stripe payment response ${response.statusCode} =${response.body}');
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody['status'];
      }
    } catch (e) {
      throw e;
    }
    return false;
  }

  Future<String> getPaypalRedirectUrl(String totalAmount) async {
    try {
      Uri url = Uri.parse(AppUrls.payPalPaymentUrl);
      Map<String, String> body = {'total_amount': totalAmount};

      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['redirect_url'];
      }
    } catch (e) {
      throw e;
    }

    return '';
  }
}

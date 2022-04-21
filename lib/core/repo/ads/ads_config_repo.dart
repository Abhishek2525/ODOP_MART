import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../api/app_urls.dart';
import '../../models/ads/ads_config_model.dart';

/// A utility class that provide a method [getAdsConfig] to get Ad configuration
class AdsConfigRepo {
  /// return Ad configuration [AdsConfig]
  Future<AdsConfig> getAdsConfig() async {
    try {
      String url =
          AppUrls.adsConfigUrl + "?device=${Platform.isAndroid ? 0 : 1}";
      http.Response r = await http.get(Uri.parse(url));

      Map<String, dynamic> data = json.decode(r?.body);

      AdsConfigModel m = AdsConfigModel.fromJson(data);
      return m?.data;
    } catch (e, t) {
      print(e);
      print(t);
      return null;
    }
  }
}

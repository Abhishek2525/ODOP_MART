import 'dart:convert';

/// A data model class for Ad
///
/// Contains add config data
class AdsConfigModel {
  bool status;
  AdsConfig data;

  AdsConfigModel({this.status, this.data});

  AdsConfigModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new AdsConfig.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class AdsConfig {
  int id;
  String type;
  String interstitialAd;
  var interstitialLink;
  var bannerLink;
  String nativeAd;
  String bannerAd;
  int status;
  String createdAt;
  String updatedAt;
  int clickCount;

  AdsConfig(
      {this.id,
      this.type,
      this.interstitialAd,
      this.interstitialLink,
      this.bannerLink,
      this.nativeAd,
      this.bannerAd,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.clickCount});

  AdsConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    interstitialAd = json['interstitial_ad'];
    interstitialLink = json['interstitial_link'];
    bannerLink = json['banner_link'];
    nativeAd = json['native_ad'];
    bannerAd = json['banner_ad'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    clickCount = json['click_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['interstitial_ad'] = this.interstitialAd;
    data['interstitial_link'] = this.interstitialLink;
    data['banner_link'] = this.bannerLink;
    data['native_ad'] = this.nativeAd;
    data['banner_ad'] = this.bannerAd;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['click_count'] = this.clickCount;
    return data;
  }

  String toString() {
    return JsonEncoder.withIndent('  ').convert(toJson());
  }
}

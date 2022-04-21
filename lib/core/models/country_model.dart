import '../api/app_urls.dart';
import '../api/http_request.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call
///       2. converting json map to actual {Dart} {object}
///       3. converting actual {Dart} {object} to json map
///
/// Represent a single [CountryModel] data that contains all
/// country[Data] list and allow using those all data in app conveniently
class CountryModel {
  bool status;
  String appUrl;
  List<Data> data;

  CountryModel({this.status, this.appUrl, this.data});

  CountryModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      appUrl = json['appUrl'];
      if (json['data'] != null) {
        data = [];
        json['data'].forEach((v) {
          data.add(new Data.fromJson(v));
        });
      }
    } catch (e, t) {
      print(e);
      print(t);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['appUrl'] = this.appUrl;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// This method call an api and retrieve all countrylist from server
  Future<void> callApi() async {
    try {
      Map<String, dynamic> res = await HttpHelper.get(AppUrls.countryUrl);
      if (res == null) return;
      if (res.isEmpty) return;
      return this._fromJson(res);
    } catch (e, t) {
      print(e);
      print(t);
    }
  }
}

/// This model class represent a country object
class Data {
  int id;
  String title;
  String url;
  String img;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.title,
      this.url,
      this.img,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

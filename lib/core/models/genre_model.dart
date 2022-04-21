import '../api/app_urls.dart';
import '../api/http_request.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call
///       2. converting json map to actual {Dart} {object}
///       3. converting actual {Dart} {object} to json map
///
/// Represent a single [GenreModel] data that contains a list of genre[Data] object
class GenreModel {
  bool status;
  String appUrl;
  List<Data> data;

  GenreModel({this.status, this.appUrl, this.data});

  GenreModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      appUrl = json['appUrl'];
      if (json['data'] != null) {
        data = <Data>[];
        json['data'].forEach((v) {
          data.add(new Data.fromJson(v));
        });
      }
    } catch (e) {
      print(e);
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

  Future<void> callApi() async {
    try {
      Map<String, dynamic> res = await HttpHelper.get(AppUrls.genreUrl);
      return _fromJson(res);
    } catch (e) {}
  }
}

class Data {
  int id;
  String name;
  String img;
  String createdAt;
  String updatedAt;

  Data({this.id, this.name, this.img, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

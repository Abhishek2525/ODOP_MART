import '../api/app_urls.dart';
import '../api/http_request.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call
///       2. converting json map to actual data {object}
///       3. converting actual data {object} to json map
///
/// Represent a single [CategoriesModel] data that contains all categories and
/// allow using those all data in app conveniently
class CategoriesModel {
  bool status;
  String appUrl;
  List<Data> data;

  CategoriesModel({this.status, this.appUrl, this.data});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
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

  /// call the api to get [CategoriesModel] data
  Future<void> callApi() async {
    try {
      Map<String, dynamic> res = await HttpHelper.get(AppUrls.categoriesUrl);
      if (res == null) return;
      if (res.isEmpty) return;
      //print(res);
      this._fromJson(res);
    } catch (e) {}
  }
}

class Data {
  int id;
  dynamic categoryId;
  int categoryTypeId;
  String name;
  String img;
  String createdAt;
  String updatedAt;
  List<Categories> categories;
  CategoryType categoryType;

  Data(
      {this.id,
      this.categoryId,
      this.categoryTypeId,
      this.name,
      this.img,
      this.createdAt,
      this.updatedAt,
      this.categories,
      this.categoryType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryTypeId = json['category_type_id'];
    name = json['name'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    categoryType = json['category_type'] != null
        ? new CategoryType.fromJson(json['category_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['category_type_id'] = this.categoryTypeId;
    data['name'] = this.name;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.categoryType != null) {
      data['category_type'] = this.categoryType.toJson();
    }
    return data;
  }
}

/// This model class represent a single video Category
class Categories {
  int id;
  int categoryId;
  int categoryTypeId;
  String name;
  String img;
  String createdAt;
  String updatedAt;

  Categories(
      {this.id,
      this.categoryId,
      this.categoryTypeId,
      this.name,
      this.img,
      this.createdAt,
      this.updatedAt});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryTypeId = json['category_type_id'];
    name = json['name'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['category_type_id'] = this.categoryTypeId;
    data['name'] = this.name;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CategoryType {
  int id;
  String type;
  String createdAt;
  String updatedAt;

  CategoryType({this.id, this.type, this.createdAt, this.updatedAt});

  CategoryType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

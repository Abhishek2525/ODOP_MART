import '../api/app_urls.dart';
import '../api/http_request.dart';
import '../utils/local_auth/local_auth_get_storage.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call to get user profile
///       2. converting json map to actual data {object}
///       3. converting actual data {object} to json map
///
/// Represent a single [ProfileModel] data object
/// that contains all information of a user profile
/// and allow using those all data in app conveniently
class ProfileModel {
  bool status;
  String appUrl;
  Data data;

  ProfileModel({this.status, this.appUrl, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    status = json['status'];
    appUrl = json['appUrl'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['appUrl'] = this.appUrl;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  /// This method make an api call by using [HttpHelper] class
  /// and get user information
  Future<void> callApi() async {
    if (LocalDBUtils.getJWTToken() == null) return;
    String token = "Bearer " + LocalDBUtils.getJWTToken();
    Map<String, dynamic> res = await HttpHelper.get(AppUrls.profileUrl,
        headers: {"Authorization": "$token"});
    if (res == null) return;
    if (res.isEmpty) return;
    // print(res);
    this._fromJson(res);
  }
}

class Data {
  int id;
  int roleId;
  String name;
  String email;
  dynamic emailVerifiedAt;
  String phone;
  dynamic avatar;
  String registerMethod;
  dynamic fbOrGoogleId;
  String createdAt;
  String updatedAt;
  dynamic role;

  Data(
      {this.id,
      this.roleId,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.phone,
      this.avatar,
      this.registerMethod,
      this.fbOrGoogleId,
      this.createdAt,
      this.updatedAt,
      this.role});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['role_id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    avatar = json['avatar'];
    registerMethod = json['register_method'];
    fbOrGoogleId = json['fb_or_google_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['register_method'] = this.registerMethod;
    data['fb_or_google_id'] = this.fbOrGoogleId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['role'] = this.role;
    return data;
  }
}

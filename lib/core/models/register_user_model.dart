import '../api/app_urls.dart';
import '../api/http_request.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call to register a user
///       2. converting json map to actual data {object}
///       3. converting actual data {object} to json map
///
/// Represent a single [RegisterUserModel] data object
/// that contains all information of a user registration
/// and allow using those all data in app conveniently
class RegisterUserModel {
  bool status;
  Data data;
  Errors errors;

  RegisterUserModel({this.status, this.data, this.errors});

  RegisterUserModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
      errors =
          json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
    } catch (e, t) {
      print(e);
      print(t);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    if (this.errors != null) {
      data['errors'] = this.errors.toJson();
    }
    return data;
  }

  /// this method call an api and perform Registration with user credentials
  /// [name] -> name of the user
  /// [email] -> users email
  /// [phone] -> users phone numner
  /// [password] -> user password
  /// [registerMethod] -> {normal registration} {google} or {facebook}
  /// [fbOrGoogleId] -> facebook user id or google user id depend on [registerMethod]
  Future<void> callApi({
    String name,
    String email,
    String phone,
    String password,
    String registerMethod,
    String fbOrGoogleId,
  }) async {
    try {
      Map<String, dynamic> res =
          await HttpHelper.post(AppUrls.registerUserUrl, body: {
        "email": email,
        "name": name,
        "phone": phone,
        "password": password,
        "register_method": registerMethod,
        "fb_or_google_id": fbOrGoogleId,
      });
      // print(res);
      if (res == null) return;
      if (res.isEmpty) return;
      this._fromJson(res);
    } catch (e, t) {
      print(e);
      print(t);
    }
  }
}

class Data {
  String name;
  String email;
  String phone;
  int roleId;
  String updatedAt;
  String createdAt;
  int id;
  String bearerToken;

  Data(
      {this.name,
      this.email,
      this.phone,
      this.roleId,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.bearerToken});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    roleId = json['role_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    bearerToken = json['bearer_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role_id'] = this.roleId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['bearer_token'] = this.bearerToken;
    return data;
  }
}

class Errors {
  List<String> email;
  List<String> phone;

  Errors({this.email, this.phone});

  Errors.fromJson(Map<String, dynamic> json) {
    if (json['email'] != null) {
      email = <String>[];
      json['email'].forEach((v) {
        email.add(v);
      });
    }
    if (json['phone'] != null) {
      phone = <String>[];
      json['phone'].forEach((v) {
        phone.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

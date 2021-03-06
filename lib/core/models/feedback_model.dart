import '../api/app_urls.dart';
import '../api/http_request.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call
///       2. converting json map to actual {Dart} {object}
///       3. converting actual {Dart} {object} to json map
///
/// Represent a single [FeedbackModel] data that contains all feedback information
///  and allow using those data in app conveniently
class FeedbackModel {
  bool success;
  String appUrl;
  Data data;

  FeedbackModel({this.success, this.appUrl, this.data});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    success = json['success'];
    appUrl = json['appUrl'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['appUrl'] = this.appUrl;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

  Future<void> callApi({
    String name,
    String phone,
    String email,
    String feedback,
  }) async {
    try {
      Map<String, dynamic> res =
          await HttpHelper.post(AppUrls.feedbackUrl, body: {
        "name": name,
        "phone": phone,
        "email": email,
        "feedback": feedback,
      });
      if (res == null) return;
      if (res.isEmpty) return;
      this._fromJson(res);
    } catch (e) {}
  }
}

/// represent a feedback response from server
class Data {
  String name;
  String email;
  String phone;
  String feedback;
  String updatedAt;
  String createdAt;
  int id;

  Data(
      {this.name,
      this.email,
      this.phone,
      this.feedback,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    feedback = json['feedback'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['feedback'] = this.feedback;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

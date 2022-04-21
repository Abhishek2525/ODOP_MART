import '../api/app_urls.dart';
import '../api/http_request.dart';
import '../utils/local_auth/local_auth_get_storage.dart';

/// A Data Model Class
///
/// only responsible for performing logout operation for user
class LogoutModel {
  /// represent status of the logout operation
  bool status;

  /// contains message from the server after performing logout operation
  String msg;

  LogoutModel({this.status, this.msg});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    return data;
  }

  /// This method perform logout operation by using [HttpHelper] class's [post]
  /// method
  Future<void> callApi() async {
    String token = "Bearer " + LocalDBUtils.getJWTToken();
    Map<String, dynamic> res = await HttpHelper.post(AppUrls.logoutUserUrl,
        headers: {"Authorization": "$token"});
    this._fromJson(res);
  }
}

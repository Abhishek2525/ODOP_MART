import '../api/app_urls.dart';
import '../api/http_request.dart';
import '../utils/local_auth/local_auth_get_storage.dart';

/// A Data Model Class
///
/// Responsible for
///      1. Making API call for performing {like} and {dislike} operation
///      2. converting json map to actual {Dart} {object}
///      3. converting actual {Dart} {object} to json map
///
/// Represent a single [LikeDislikeModel] data object that contains all feedback information
///  and allow using those data in app conveniently
class LikeDislikeModel {
  int status;
  String message;

  LikeDislikeModel({this.status, this.message});

  LikeDislikeModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }

  /// This method performs Like operation
  Future<void> callLikeApi({int videoId}) async {
    String token = "Bearer " + LocalDBUtils.getJWTToken();
    try {
      Map<String, dynamic> res = await HttpHelper.post(
        AppUrls.likeUrl,
        body: {
          "videoid": videoId,
        },
        headers: {
          "Authorization": token,
        },
      );
      if (res == null) return;
      if (res.isEmpty) return;
      // print(res);
      this._fromJson(res);
    } catch (e) {}
  }

  /// This method performs dislike operation
  Future<void> callDislikeApi({int videoId}) async {
    String token = "Bearer " + LocalDBUtils.getJWTToken();
    try {
      Map<String, dynamic> res = await HttpHelper.post(
        AppUrls.dislikeUrl,
        body: {
          "videoid": videoId,
        },
        headers: {
          "Authorization": token,
        },
      );
      if (res == null) return;
      if (res.isEmpty) return;
      //print(res);
      this._fromJson(res);
    } catch (e) {}
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../view/pages/favorite_page/Favorite_Page.dart';
import '../../api/app_urls.dart';
import '../../api/http_request.dart';
import '../../utils/local_auth/local_auth_get_storage.dart';

/// A repository class to perform network operation,
/// to performs [FavoritePage] pages various activity
class WishListRepo extends GetConnect {
  /// This method call an api and remove an video to favorite list in the server
  deleteFavorite(String id) async {
    if (id == null) return;

    if (LocalDBUtils.getJWTToken() == null) return;
    String token = "Bearer " + LocalDBUtils.getJWTToken();

    Map<String, String> headers = {"Authorization": "$token"};

    try {
      Response r = await delete(
        AppUrls.wishListSingleDeleteUrl + "$id",
        headers: headers,
      );
      return r?.statusCode;
    } catch (e, t) {
      print(e);
      print(t);
      return 404;
    }
  }

  /// This method call an api and add a video to favorite list in the server
  addFavorite(String id) async {
    if (id == null) return;

    if (LocalDBUtils.getJWTToken() == null) return;
    String token = "Bearer " + LocalDBUtils.getJWTToken();

    Map<String, String> headers = {"Authorization": "$token"};

    try {
      Map<String, dynamic> r = await HttpHelper.post(
        AppUrls.addWishList,
        headers: headers,
        body: {"videoid": "$id"},
      );
      if (r == null) return 404;
      if (r['status'] == true) return 200;
      return 404;
    } catch (e, t) {
      print(e);
      print(t);
      return 404;
    }
  }

  /// this method call an api and check whether a video is a favorite video or not
  Future<bool> isFavorite(String videoId) async {
    String url = AppUrls.isFavUrl(videoId);
    try {
      String token = LocalDBUtils.getJWTToken();
      if (token == null) {
        return false;
      }
      var headers = {'Authorization': "Bearer " + token};

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var map = jsonDecode(response.body);
        return map['status'];
      } else {
        return false;
      }
    } catch (error) {}

    return false;
  }
}

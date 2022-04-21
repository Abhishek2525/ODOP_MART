import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../api/app_urls.dart';
import '../../models/home_categories_model.dart';
import '../../models/video_details_model.dart';

/// A repository class to perform network operation for deep linking
/// related operations
class DeepLinkRepo {
  /// This method get a video from server by video id and returns the video
  Future<HomeData> getVideoFromDeepLink(String id) async {
    String url = '${AppUrls.baseUrl}api/videos/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var map = jsonDecode(response.body);
        Video video = Video.fromJson(map['data']['video']);
        return video;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}

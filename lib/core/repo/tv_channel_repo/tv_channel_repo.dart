import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../api/app_urls.dart';
import '../../models/tv_channel.dart';

/// A repository class to perform network operation,
/// for getting al [TvChannel] list from server
class TvChannelRepo {
  /// This method makes the network call and get the [TvChannel] list from server
  Future<List<TvChannel>> getTvChannelList() async {
    List<TvChannel> channelList = [];
    try {
      Uri url = Uri.parse(AppUrls.getAllTvChannelUrl);

      final response = await http.get(url);

      log('channel list = ${response.body}');

      if (response.statusCode == 200) {
        var resMap = jsonDecode(response.body);
        if (resMap['status'] == true) {
          for (var json in resMap['data']) {
            channelList.add(TvChannel.fromJson(json));
          }
        }
      } else {
        print('get all tv channel api call failed ');
        print('status code = ${response.statusCode}');
      }
    } catch (error) {
      print('\u{26A0}');
      print('error = $error');
      print('\u{26A0}');
    }

    return channelList;
  }
}

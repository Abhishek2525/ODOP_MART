import '../api/app_urls.dart';
import '../api/http_request.dart';
import 'tv_series_seasons_model.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call to get TV series seasons episodes
///       by TV-series type and TV-series season ID from server
///
///       2. converting json map to actual data {object}
///       3. converting actual data {object} to json map
///
/// Represent a single [TVSeriesSeasonEpisodeModel] data object
/// that contains a list of tv series episodes[Data]
class TVSeriesSeasonEpisodeModel {
  int status;
  List<Data> data;

  TVSeriesSeasonEpisodeModel({this.status, this.data});

  TVSeriesSeasonEpisodeModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<void> callApi({String type, int seasonid, int episode}) async {
    try {
      Map<String, dynamic> res = await HttpHelper.post(
        AppUrls.tvSeriesSeasonEpisodeUrl,
        body: {
          "type": type,
          "seasonId": seasonid,
          "episode": episode,
        },
      );
      if (res == null) return;
      if (res.isEmpty) return;
      this._fromJson(res);
    } catch (e) {}
  }
}

class Data {
  int id;
  int tvSeriesId;
  String season;
  String img;
  String createdAt;
  String updatedAt;
  List<Episodes> episodes;

  Data(
      {this.id,
      this.tvSeriesId,
      this.season,
      this.img,
      this.createdAt,
      this.updatedAt,
      this.episodes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tvSeriesId = json['tv_series_id'];
    season = json['season'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['episodes'] != null) {
      episodes = <Episodes>[];
      json['episodes'].forEach((v) {
        episodes.add(new Episodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tv_series_id'] = this.tvSeriesId;
    data['season'] = this.season;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.episodes != null) {
      data['episodes'] = this.episodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import '../api/app_urls.dart';
import '../api/http_request.dart';
import 'home_categories_model.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call
///       2. converting json map to actual data {object}
///       3. converting actual data {object} to json map
///
/// Represent a single [HistoryDataModel] data that contains all videos and
/// allow using those all data in app conveniently
class AllVideosModel {
  bool status;
  String appUrl;
  int maxLike;
  List<Data> data;

  AllVideosModel({this.status, this.appUrl, this.data, this.maxLike});

  AllVideosModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      appUrl = json['appUrl'];
      maxLike = json['max_like'];
      if (json['data'] != null) {
        data = <Data>[];
        json['data'].forEach((v) {
          data.add(new Data.fromJson(v));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['appUrl'] = this.appUrl;
    data['maxLike'] = this.appUrl;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Future<void> callApi() async {
    try {
      Map<String, dynamic> res = await HttpHelper.get(AppUrls.allVideosUrl);
      if (res == null) return;
      if (res.isEmpty) return;
      //print(res);
      return this._fromJson(res);
    } catch (e) {
      print(e);
    }
  }
}

/// A data class to present video object
class Data extends HomeData {
  int id;
  int categoryId;
  String title;
  String duration;
  String videoTypeId;
  String videoUrl;
  String thumbnail;
  String description;
  int isSeries;
  int commentAllow;
  int videoDisplay;
  dynamic tvSeriesEpisodeNo;
  dynamic tvSeriesSeasonId;
  String createdAt;
  String updatedAt;
  int isPremium;

  Data(
      {this.id,
      this.categoryId,
      this.title,
      this.duration,
      this.videoTypeId,
      this.videoUrl,
      this.thumbnail,
      this.description,
      this.isSeries,
      this.commentAllow,
      this.videoDisplay,
      this.tvSeriesEpisodeNo,
      this.tvSeriesSeasonId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    duration = json['duration'];
    videoTypeId = json['video_type_id'];
    videoUrl = json['video_url'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    isSeries = json['is_series'];
    commentAllow = json['comment_allow'];
    videoDisplay = json['video_display'];
    tvSeriesEpisodeNo = json['tv_series_episode_no'];
    tvSeriesSeasonId = json['tv_series_season_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isPremium = json['is_premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['duration'] = this.duration;
    data['video_type_id'] = this.videoTypeId;
    data['video_url'] = this.videoUrl;
    data['thumbnail'] = this.thumbnail;
    data['description'] = this.description;
    data['is_series'] = this.isSeries;
    data['comment_allow'] = this.commentAllow;
    data['video_display'] = this.videoDisplay;
    data['tv_series_episode_no'] = this.tvSeriesEpisodeNo;
    data['tv_series_season_id'] = this.tvSeriesSeasonId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_premium'] = this.isPremium;
    return data;
  }

  @override
  void setIsPriem() {
    // TODO: implement setIsPriem
  }
}

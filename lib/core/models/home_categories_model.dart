import '../api/app_urls.dart';
import '../api/http_request.dart';

/// An abstract class That represent a single video object
///
/// This Custom Data model is the actual representative of a video object
///
/// A Data Model
///
/// Responsible for
///       1. Making API call
///       2. converting json map to actual {Dart} {object}
///       3. converting actual {Dart} {object} to json map
///
abstract class HomeData {
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
  dynamic videoResolutionId;
  int like;
  int dislike;
  int isPremium;

  void setIsPriem();

  Map<String, dynamic> toJson();
}

abstract class CommonHomeModel extends HomeData {
  HomeData returnHomeData();
}

class HomeCategoriesModel {
  bool status;
  String appUrl;
  Data data;

  HomeCategoriesModel({this.status, this.appUrl, this.data});

  HomeCategoriesModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      appUrl = json['appUrl'];
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    } catch (e) {
      print(e);
    }
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

  Future<void> callApi() async {
    try {
      Map<String, dynamic> res =
          await HttpHelper.get(AppUrls.homeCategoriesUrl);
      if (res == null) return;
      if (res.isEmpty) return;
      this._fromJson(res);
    } catch (e) {}
  }
}

class Data {
  Map<String, List<CommonHomeModel>> dataMap = Map();
  List<String> dataMapKeys = [];

  Data();

  Data.fromJson(Map<String, dynamic> json) {
    List<String> keys = json.keys?.toList();

    try {
      for (int i = 0; i < keys.length; i++) {
        List list = json[keys[i]];
        List<VideoDotVideo> videoDotVideoList = [];
        List<VideoModel> videoModelList = [];
        list?.forEach((e) {
          Map<String, dynamic> mp = e;
          if (mp.containsKey('video')) {
            videoDotVideoList.add(new VideoDotVideo.fromJson(mp));
          } else {
            videoModelList.add(VideoModel.fromJson(mp));
          }
        });

        if (videoDotVideoList.length > 0) {
          dataMap[keys[i]] = videoDotVideoList;
          continue;
        }

        if (videoModelList.length > 0) {
          dataMap[keys[i]] = videoModelList;
        }
      }
    } catch (e, t) {
      print(e);
      print(t);
    }

    dataMapKeys = dataMap.keys.toList();
    dataMap.forEach((key, value) {
      print("$key ${value.length}");
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class VideoModel extends CommonHomeModel {
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
  dynamic videoResolutionId;
  int like;
  int dislike;
  int isPremium;

  @override
  HomeData returnHomeData() => this;

  VideoModel(
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
      this.updatedAt,
      this.videoResolutionId,
      this.like,
      this.dislike});

  VideoModel.fromJson(Map<String, dynamic> json) {
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
    videoResolutionId = json['video_resolution_id'];
    like = json['like'];
    dislike = json['dislike'];
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
    data['video_resolution_id'] = this.videoResolutionId;
    data['like'] = this.like;
    data['dislike'] = this.dislike;
    data['is_premium'] = this.isPremium;
    return data;
  }

  @override
  void setIsPriem() {
    // TODO: implement setIsPriem
  }
}

class VideoDotVideo extends CommonHomeModel {
  VideoModel video;

  VideoDotVideo({
    this.video,
  });

  VideoDotVideo.fromJson(Map<String, dynamic> json) {
    video =
        json['video'] != null ? new VideoModel.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    return data;
  }

  @override
  HomeData returnHomeData() => this?.video;

  @override
  void setIsPriem() {
    // TODO: implement setIsPriem
  }
}

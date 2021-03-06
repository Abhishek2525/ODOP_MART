import '../api/app_urls.dart';
import '../api/http_request.dart';
import 'home_categories_model.dart';

/// A Data Model Class
///
/// Responsible for
///       1. Making API call to get all sub category list
///       2. converting json map to actual data {object}
///       3. converting actual data {object} to json map
///
/// Represent a single [SubCategoriesModel] data object
/// that contains a list of subcategory [Data]
class SubCategoriesModel {
  bool status;
  String appUrl;
  Data data;

  SubCategoriesModel({this.status, this.appUrl, this.data});

  SubCategoriesModel.fromJson(Map<String, dynamic> json) {
    this._fromJson(json);
  }

  _fromJson(Map<String, dynamic> json) {
    status = json['status'];
    appUrl = json['appUrl'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

  /// This method call an Api using [HttpHelper] class to get
  /// the subcategory list
  Future<void> callApi({int id}) async {
    try {
      Map<String, dynamic> res =
          await HttpHelper.get(AppUrls.subCategoriesUrl + id.toString());
      if (res == null) return;
      if (res.isEmpty) return;
      this._fromJson(res);
    } catch (e) {}
  }
}

class Data {
  List<Subcategory> subcategory;
  CategoryVideo categoryVideo;

  Data({this.subcategory, this.categoryVideo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['subcategory'] != null) {
      subcategory = <Subcategory>[];
      json['subcategory'].forEach((v) {
        subcategory.add(new Subcategory.fromJson(v));
      });
    }
    categoryVideo = json['category-video'] != null
        ? new CategoryVideo.fromJson(json['category-video'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory.map((v) => v.toJson()).toList();
    }
    if (this.categoryVideo != null) {
      data['category-video'] = this.categoryVideo.toJson();
    }
    return data;
  }
}

/// This model class represent a SubCategory object
class Subcategory {
  int id;
  int categoryId;
  int categoryTypeId;
  String name;
  String img;
  String createdAt;
  String updatedAt;

  Subcategory(
      {this.id,
      this.categoryId,
      this.categoryTypeId,
      this.name,
      this.img,
      this.createdAt,
      this.updatedAt});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryTypeId = json['category_type_id'];
    name = json['name'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['category_type_id'] = this.categoryTypeId;
    data['name'] = this.name;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CategoryVideo {
  int currentPage;
  List<Data1> data1;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Links> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  CategoryVideo(
      {this.currentPage,
      this.data1,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  CategoryVideo.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data1 = <Data1>[];
      json['data'].forEach((v) {
        data1.add(new Data1.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data1 != null) {
      data['data'] = this.data1.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

/// A data class to present video object
class Data1 extends HomeData {
  int id;
  int categoryId;
  String title;
  String duration;
  String videoTypeId;
  String videoUrl;
  String thumbnail;
  String description;
  int like;
  int dislike;
  int isSeries;
  int commentAllow;
  int videoDisplay;
  dynamic tvSeriesEpisodeNo;
  dynamic tvSeriesSeasonId;
  String createdAt;
  String updatedAt;
  int isPremium;

  Data1(
      {this.id,
      this.categoryId,
      this.title,
      this.duration,
      this.videoTypeId,
      this.videoUrl,
      this.thumbnail,
      this.description,
      this.like,
      this.dislike,
      this.isSeries,
      this.commentAllow,
      this.videoDisplay,
      this.tvSeriesEpisodeNo,
      this.tvSeriesSeasonId,
      this.createdAt,
      this.updatedAt});

  Data1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    duration = json['duration'];
    videoTypeId = json['video_type_id'];
    videoUrl = json['video_url'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    like = json['like'];
    dislike = json['dislike'];
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
    data['like'] = this.like;
    data['dislike'] = this.dislike;
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

class Links {
  dynamic url;
  dynamic label;
  bool active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}

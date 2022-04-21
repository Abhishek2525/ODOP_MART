/// A Data Model Class
///
/// Responsible for
///       1. Represent Sponsor List
///       2. converting json map to actual data {object}
///       3. converting actual data {object} to json map
///
/// Represent a single [SponsorModel] data object
/// that contains all Sponsor's
/// and allow using those all data in app conveniently
class SponsorModel {
  bool status;
  String action;
  String appUrl;
  List<SponsorData> data;

  SponsorModel({this.status, this.action, this.appUrl, this.data});

  SponsorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    action = json['action'];
    appUrl = json['appUrl'];
    if (json['data'] != null) {
      data = <SponsorData>[];
      json['data'].forEach((v) {
        v['action'] = action;
        data.add(new SponsorData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['action'] = this.action;
    data['appUrl'] = this.appUrl;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SponsorData {
  int id;
  var videoId;
  String action;
  String title;
  String url;
  String mediaType;
  String img;
  String createdAt;
  String updatedAt;
  int sponsorTypeId;
  var video;
  SponsorType sponsorType;

  SponsorData({
    this.id,
    this.videoId,
    this.title,
    this.url,
    this.mediaType,
    this.img,
    this.createdAt,
    this.updatedAt,
    this.sponsorTypeId,
    this.video,
    this.sponsorType,
    this.action,
  });

  SponsorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoId = json['video_id'];
    title = json['title'];
    url = json['url'];
    mediaType = json['media_type'];
    img = json['img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sponsorTypeId = json['sponsor_type_id'];
    video = json['video'];
    action = json['action'];
    sponsorType = json['sponsor_type'] != null
        ? new SponsorType.fromJson(json['sponsor_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['url'] = this.url;
    data['media_type'] = this.mediaType;
    data['img'] = this.img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sponsor_type_id'] = this.sponsorTypeId;
    data['video'] = this.video;
    data['action'] = this.action;
    if (this.sponsorType != null) {
      data['sponsor_type'] = this.sponsorType.toJson();
    }
    return data;
  }
}

class SponsorType {
  int id;
  String position;
  String createdAt;
  String updatedAt;

  SponsorType({this.id, this.position, this.createdAt, this.updatedAt});

  SponsorType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['position'] = this.position;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

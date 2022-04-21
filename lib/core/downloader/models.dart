import 'dart:convert';
import 'dart:io';

//import 'package:flutter_downloader/flutter_downloader.dart';

import '../models/home_categories_model.dart';

class TaskInfo {
  String name;
  String link;
  String taskId;
  int progress = 0;
  var status;
  // DownloadTaskStatus status = DownloadTaskStatus.undefined;

  String downloadedPath = '';

  TaskInfo({
    this.name,
    this.link,
    this.status,
    this.taskId,
    this.progress,
  });

  bool isExistFile() {
    return File(this.downloadedPath ?? "").existsSync();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['name'] = this.name;
    map['link'] = this.link;
    map['taskId'] = this.taskId;
    map['progress'] = this.progress;
    map['status'] = this.status?.value ?? 0;
    map['downloadedPath'] = this.downloadedPath;
    return map;
  }

  TaskInfo.fromJson(Map<String, dynamic> map) {
    this.name = map['name'];
    this.link = map['link'];
    this.taskId = map['taskId'];
    this.progress = map['progress'];
    // this.status =
    //     DownloadTaskStatus(int.tryParse(map['status']?.toString()) ?? 0);
    this.downloadedPath = map['downloadedPath'];
  }

  String toString() {
    return json.encode(toJson());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskInfo &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => (taskId.hashCode);
}
//
// class ItemHolder {
//   final String name;
//   final TaskInfo task;
//
//   ItemHolder({this.name, this.task});
// }

class DownloadedDataModel {
  TaskInfo task;
  HomeData data;

  DownloadedDataModel({this.task, this.data});

  DownloadedDataModel.fromJson(
    Map<String, dynamic> mp,
  ) {
    task = TaskInfo.fromJson(mp['task']);
    data = DownloadData.fromJson(mp['data']);
  }

  bool isExistFile() {
    bool b = File(this.task?.downloadedPath ?? "").existsSync();
    print("file isExistFile $b :=> ${this.task?.downloadedPath}");
    return b;
  }

  toJson() {
    Map<String, dynamic> mp = <String, dynamic>{};

    mp['task'] = task?.toJson();
    mp['data'] = data?.toJson();
    return mp;
  }

  String toString() {
    return json.encode(toJson());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedDataModel &&
          runtimeType == other.runtimeType &&
          task == other.task;

  @override
  int get hashCode => task.hashCode;
}

class DownloadData extends HomeData {
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['duration'] = this.duration;
    data['video_type_id'] = this.videoTypeId;
    data['video_resolution_id'] = this.videoResolutionId;
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

  DownloadData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    duration = json['duration'];
    videoTypeId = json['video_type_id'];
    videoResolutionId = json['video_resolution_id'];
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

  @override
  void setIsPriem() {
    // TODO: implement setIsPriem
  }
}

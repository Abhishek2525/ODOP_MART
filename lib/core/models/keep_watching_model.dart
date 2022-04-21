/// A Data Model Class
///
/// Responsible for
///       1. converting json map to actual {Dart} {object}
///       2. converting actual {Dart} {object} to json map
///
/// Represent a video object with only 3 field information
///
/// This particular Data Class is designed for implementing keep watching
/// feature

class KeepWatchingModel {
  int videoId;
  int playedTill;
  int totalDuration;

  KeepWatchingModel({this.videoId, this.playedTill, this.totalDuration});

  KeepWatchingModel.fromJson(Map<String, dynamic> json) {
    videoId = json['videoId'];
    playedTill = json['playedTill'];
    totalDuration = json['totalDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoId'] = this.videoId;
    data['playedTill'] = this.playedTill;
    data['totalDuration'] = this.totalDuration;
    return data;
  }
}

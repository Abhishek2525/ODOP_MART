/// A Data Model Class
///
/// Responsible for
///       1. converting json map to actual data {object}
///       2. converting actual data {object} to json map
///
/// Represent a single [TvChannel] data object
/// that contains all information of a TV Channel
class TvChannel {
  int id;
  int categoryId;
  int stremingTypeId;
  String name;
  String img;
  String streamUrl;
  String createdAt;
  String updatedAt;
  StremingType stremingType;
  int isPremium;

  TvChannel(
      {this.id,
      this.categoryId,
      this.stremingTypeId,
      this.name,
      this.img,
      this.streamUrl,
      this.createdAt,
      this.updatedAt,
      this.isPremium,
      this.stremingType});

  TvChannel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    stremingTypeId = json['streming_type_id'];
    name = json['name'];
    img = json['img'];
    streamUrl = json['stream_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isPremium = json['is_premium'];
    stremingType = json['streming_type'] != null
        ? new StremingType.fromJson(json['streming_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['streming_type_id'] = this.stremingTypeId;
    data['name'] = this.name;
    data['img'] = this.img;
    data['stream_url'] = this.streamUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_premium'] = this.isPremium;
    if (this.stremingType != null) {
      data['streming_type'] = this.stremingType.toJson();
    }
    return data;
  }
}

class StremingType {
  int id;
  String type;
  String createdAt;
  String updatedAt;

  StremingType({this.id, this.type, this.createdAt, this.updatedAt});

  StremingType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

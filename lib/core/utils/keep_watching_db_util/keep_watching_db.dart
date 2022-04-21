import 'dart:convert';

import 'package:get_storage/get_storage.dart';

import '../../constant/storage_constant.dart';
import '../../models/keep_watching_model.dart';

/// A Database Helper class
///
/// Designed as Singleton manner
///
/// Mainly designed for implementing {Keep Watching} feature
class KeepWatchingDB {
  /// crate an singleton object using private constructor
  static KeepWatchingDB ins = KeepWatchingDB._();

  /// private constructor
  KeepWatchingDB._();

  /// Initialize the singleton object
  init() async {
    await GetStorage.init(StorageConstant.keep_db_name);
  }

  /// Save a video in [Database] using [GetStorage]
  /// to maintain the queue of keep watching
  Future<void> addToKeepWatchingQueue(KeepWatchingModel newModel) async {
    try {
      final storage = GetStorage(StorageConstant.keep_db_name);

      /// get keep watching video list from Database
      List<dynamic> videoList =
          storage.read(StorageConstant.keep_watching_list);
      if (videoList == null) {
        videoList = [];
      }

      bool exist = false;

      /// Check whether the current video is already exist in Database
      for (int i = 0; i < videoList.length; i++) {
        KeepWatchingModel prevModel =
            KeepWatchingModel.fromJson(jsonDecode(videoList[i]));
        if (prevModel.videoId == newModel.videoId) {
          videoList.removeAt(i);
          videoList.add(jsonEncode(newModel.toJson()));
          exist = true;
          break;
        }
      }

      /// if the video already saved as keep watching
      /// then update the previous value with new value
      if (!exist) {
        if (videoList.length > 10) {
          videoList.removeAt(0);
        }
        videoList.add(jsonEncode(newModel.toJson()));
      }

      /// Save the new keep watching video list/queue to Database
      await storage.remove(StorageConstant.keep_watching_list);
      await storage.write(StorageConstant.keep_watching_list, videoList);
      await storage.save();
    } catch (error) {}
  }

  /// Simply returns all the videos are saved id Database for Keep Watching feature
  Future<dynamic> getKeepWatchingList() async {
    final storage = GetStorage(StorageConstant.keep_db_name);
    var result = await storage.read(StorageConstant.keep_watching_list);
    return result;
  }
}

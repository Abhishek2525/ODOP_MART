import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../models/history/history_data_model.dart';
import '../models/home_categories_model.dart';
import '../models/keep_watching_model.dart';
import '../utils/keep_watching_db_util/keep_watching_db.dart';
import '../utils/local_auth/local_auth_get_storage.dart';

/// A [GetxController] for Implement and provide functionality
/// of [KeepWatching] feature
class KeepWatchingController extends GetxController {
  RxList<HomeData> keepWatchingVideoList = <HomeData>[].obs;
  RxList<KeepWatchingModel> keepWatchingModelList = <KeepWatchingModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    generateKeepWatcingVideoList();
  }

  /// This method save a video in keep watching videos list in databse
  void addToKeepWatchingQueue(
      {@required String videoId,
      @required int playedTill,
      @required int totalDuration}) async {
    /// check user is logged in or not
    String token = LocalDBUtils.getJWTToken();
    if (token == null || playedTill >= (totalDuration - 10)) {
      return;
    }

    ///Add the video to keep watching list
    KeepWatchingModel keepWatchingModel = KeepWatchingModel(
      videoId: int.parse(videoId),
      playedTill: playedTill,
      totalDuration: totalDuration,
    );

    await KeepWatchingDB.ins.addToKeepWatchingQueue(keepWatchingModel);
    generateKeepWatcingVideoList();
  }

  /// This method read keep watching videos from database and generate
  /// a video list from history video list.
  void generateKeepWatcingVideoList() async {
    List<dynamic> keepList = await KeepWatchingDB.ins.getKeepWatchingList();

    if (keepList != null) {
      keepList = keepList.reversed.toList();

      HistoryDataModel historyDataModel = HistoryDataModel();
      await historyDataModel.callApi();

      keepWatchingVideoList.clear();
      keepWatchingModelList.clear();
      for (int i = 0; i < keepList.length && i < 10; i++) {
        KeepWatchingModel keepWatchingModel =
            KeepWatchingModel.fromJson(jsonDecode(keepList[i]));

        for (HistoryUnitData historyUnitData
            in historyDataModel?.data?.data ?? []) {
          int id = historyUnitData?.video?.id;
          if (id == keepWatchingModel.videoId) {
            keepWatchingVideoList.add(historyUnitData?.video);
            keepWatchingModelList.add(keepWatchingModel);
            break;
          }
        }
      }
    }
  }
}

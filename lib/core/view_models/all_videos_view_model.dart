import 'package:get/get.dart';

import '../../view/pages/all_video_page/all_video_page.dart';
import '../models/all_videos_model.dart';

int maxLikeForFilter = 0;

/// This class is a controller of [AllVideoPage] Widget
///
/// Allow to manage [AllVideoPage] state
///
/// Here we are using [Get] as State Management Library
/// Allow to update User Interface in runtime of application and separating
/// the logical portion of application from View
class AllVideosViewModel extends GetxController {
  /// Contains all videos which are getting latter on from server
  Rx<AllVideosModel> allVideosModel = AllVideosModel().obs;

  /// Trace whether video list is retrieving or retrieved
  Rx<bool> allVideoLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllVideosMethod();
  }

  /// This method call an api for [AllVideosModel] and update [allVideoLoading]
  /// with new value from internet
  void getAllVideosMethod() async {
    allVideoLoading.value = true;
    AllVideosModel tempModel = AllVideosModel();

    await tempModel.callApi();
    allVideoLoading.value = false;
    allVideosModel.value = tempModel;
  }
}

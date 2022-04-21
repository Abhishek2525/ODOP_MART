import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../view/pages/video_details/video_details_page.dart';
import '../models/category_maylike_model.dart';
import '../models/home_categories_model.dart';
import '../models/like_dislike_model.dart';
import '../models/video_details_model.dart';

/// A [GetxController] to mange state and logical operations of [VideoDetailsPage]
class VideoDetailsViewModel extends GetxController {
  HomeData _initialData;

  /// A constructor for initializing the object
  VideoDetailsViewModel(this._initialData) {
    liked.value = false;
    unLiked.value = false;
    initialData = _initialData.obs;
    loadingVideo.value = false;
    update();
    loadingDetails.value = true;
    getVideoDetailsMethod(
        initialData?.value?.id?.toString(), initialData?.value?.categoryId);
  }

  newInit(HomeData initialData) {
    liked.value = false;
    unLiked.value = false;
    loadingVideo.value = false;
    update();
    loadingDetails.value = true;
    getVideoDetailsMethod(initialData?.id?.toString(), initialData?.categoryId);
  }

  Rx<VideoDetailsModel> videoDetailsModel = VideoDetailsModel().obs;

  Rx<HomeData> initialData;

  RxBool liked = false.obs;
  RxBool unLiked = false.obs;

  Rx<bool> loadingVideo = true.obs as Rx<bool>;
  Rx<bool> loadingDetails = true.obs as Rx<bool>;

  LikeDislikeModel likeDislikeModel = LikeDislikeModel();

  @override
  void onInit() {
    refresh();
    getVideoDetailsMethod(
      initialData?.value?.id?.toString(),
      initialData?.value?.categoryId,
    );
    super.onInit();
  }

  /// perform like operation
  void newPerformLike(){
    if(liked.value == false){
      initialData?.value?.like++;
      if(unLiked.value == true){
        initialData?.value?.dislike--;
      }
    }else{
      initialData?.value?.like--;
    }

    liked.value = !liked.value;
    if(unLiked.value == true){
      unLiked.value = false;
    }
  }

  /// perform unlike
  void newPerformUnlike(){

    if(unLiked.value == false){
      initialData?.value?.dislike++;
      if(liked.value == true){
        initialData?.value?.like--;
      }
    }else{
      initialData?.value?.dislike--;
    }

    unLiked.value = !unLiked.value;
    if(liked.value == true){
      liked.value = false;
    }
  }

  /// This method retrieve video information from server by video [id]
  ///
  /// and retrieve similar type videos from server by category id [catId]
  void getVideoDetailsMethod(String id, int catId) async {
    loadingDetails.value = true;
    await videoDetailsModel.value.callApi(id);
    await categoryMaylikeModel.callApi(id: catId);
    loadingDetails.value = false;
    update();
  }

  /// reinitialize the object with new values
  void refreshData(HomeData data) async {
    liked.value = false;
    unLiked.value = false;
    loadingVideo.value = true;
    loadingDetails.value = true;

    /// handle logic to update video player
    update();
    await Future.delayed(Duration(milliseconds: 100));
    initialData?.value = data;
    loadingVideo.value = false;
    update();

    /// Get similar type video from server
    getCategoryMaylike(id: initialData?.value?.categoryId);
    await videoDetailsModel.value.callApi(initialData?.value?.id.toString());
    loadingDetails.value = false;
    update();
  }

  /// This method retrieve similar type of videos based on which video
  /// is playing currently
  void getCategoryMaylike({int id}) async {
    CategoryMaylikeModel tempModel = CategoryMaylikeModel();
    try {
      await tempModel.callApi(id: id);
    } catch (error) {
      print('$error');
    }
    categoryMaylikeModel = tempModel;
    update();
  }

  /// This field contains the list of similar videos of currently plaing video
  CategoryMaylikeModel categoryMaylikeModel = CategoryMaylikeModel();

  /// This method performs video like operation
  void getLikeVideoMethod(
      {@required int videoId, @required int currentStatus}) async {
    if (currentStatus == 1) {
      videoDetailsModel?.value?.data?.video?.userLike = 0;
      videoDetailsModel?.value?.data?.video?.like--;
    } else {
      videoDetailsModel?.value?.data?.video?.userLike = 1;
      videoDetailsModel?.value?.data?.video?.like++;

      videoDetailsModel?.value?.data?.video?.userDislike = 0;
    }

    refresh();

    LikeDislikeModel tempModel = LikeDislikeModel();
    await tempModel.callLikeApi(videoId: videoId);
    likeDislikeModel = tempModel;

    update();
  }

  /// This method performs video dislike operation
  void getDislikeVideoMethod(
      {@required int videoId, @required int currentStatus}) async {
    if (currentStatus == 1) {
      videoDetailsModel?.value?.data?.video?.userDislike = 0;
      videoDetailsModel?.value?.data?.video?.dislike--;
    } else {
      videoDetailsModel?.value?.data?.video?.userDislike = 1;
      videoDetailsModel?.value?.data?.video?.dislike++;

      videoDetailsModel?.value?.data?.video?.userLike = 0;
    }

    refresh();

    LikeDislikeModel tempModel = LikeDislikeModel();
    await tempModel.callDislikeApi(videoId: videoId);
    likeDislikeModel = tempModel;
    update();
  }
}

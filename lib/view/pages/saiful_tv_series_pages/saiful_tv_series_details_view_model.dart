import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import '../../../core/models/category_maylike_model.dart';
import '../../../core/models/home_categories_model.dart';
import '../../../core/models/like_dislike_model.dart';
import '../../../core/models/tv_series_seasons_model.dart';
import '../../../core/models/video_details_model.dart';
import '../../../core/view_models/tv_series_view_model.dart';

class SaifulTvSeriesDetailsViewModel extends GetxController {
  TvSeriesSeasonsModel tvSeriesSeasonsModel;
  HomeData _initialData;
  List<HomeData> _episodeList;

  TvSeriesViewModel _tvSeriesViewModel = Get.put(TvSeriesViewModel());

  SaifulTvSeriesDetailsViewModel(this._initialData, this._episodeList) {
    this.tvSeriesSeasonsModel = _tvSeriesViewModel.tvSeriesSeasonsModel.value;
    initialData = _initialData.obs;
    episodesList = _episodeList.obs;
    seasonNumber.value = initialData.value.tvSeriesSeasonId.toString();
    loadingVideo.value = false;
    update();
    loadingDetails.value = true;
    getVideoDetailsMethod(
        initialData?.value?.id?.toString(), initialData?.value?.categoryId);
  }

  Rx<VideoDetailsModel> videoDetailsModel = VideoDetailsModel().obs;

  Rx<HomeData> initialData;
  RxList<HomeData> episodesList;
  Rx<String> seasonNumber = ''.obs;

  Rx<bool> loadingVideo = true.obs;
  Rx<bool> loadingDetails = true.obs;

  LikeDislikeModel likeDislikeModel = LikeDislikeModel();


  /// like unlike
  RxBool liked = false.obs;
  RxBool unLiked = false.obs;

  @override
  void onInit() {
    refresh();
    getVideoDetailsMethod(
        initialData?.value?.id?.toString(), initialData?.value?.categoryId);
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


  void getVideoDetailsMethod(String id, int catId) async {
    loadingDetails.value = true;
    await videoDetailsModel.value.callApi(id);
    loadingDetails.value = false;
    update();
  }

  void refreshData(HomeData data) async {
    loadingVideo.value = true;
    loadingDetails.value = true;

    /// handle logic to update video player
    update();
    await Future.delayed(Duration(milliseconds: 100));
    initialData?.value = data;
    loadingVideo.value = false;
    update();

    getCategoryMaylike(id: initialData?.value?.categoryId);
    await videoDetailsModel.value.callApi(initialData?.value?.id.toString());
    loadingDetails.value = false;
    update();
  }

  void refreshLikeData(HomeData data) async {
    initialData?.value = data;
    await videoDetailsModel.value.callApi(initialData?.value?.id.toString());
    update();
  }

  void getCategoryMaylike({int id}) async {
    CategoryMaylikeModel tempModel = CategoryMaylikeModel();
    try {
      await tempModel.callApi(id: id);
    } catch (error) {
      print('$error');
    }
    update();
  }

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

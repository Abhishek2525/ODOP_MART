import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iotflixcinema/core/services/premium_video_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/controllers/similar_to_this_video_list_traker.dart';
import '../../../../core/models/home_categories_model.dart';
import '../../../../core/view_models/VideoDetailsViewModel.dart';
import '../../../../core/view_models/fevorite_view_model.dart';
import '../../../../core/view_models/keep_watching_controller.dart';
import '../../../../core/view_models/play_from_controller.dart';
import '../../../../core/view_models/video_player_controllers/app_player_controller.dart';
import '../../../../core/view_models/video_view_view_model.dart';

class YoutubePlayerView extends StatefulWidget {
  final String url;
  final String videoId;
  final String videoName;

  YoutubePlayerView(this.url, this.videoId, this.videoName);

  @override
  _YoutubePlayerViewState createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends State<YoutubePlayerView> {
  YoutubePlayerCustomCntroller customController;

  @override
  void initState() {
    super.initState();

    customController = Get.put(YoutubePlayerCustomCntroller());
    customController.playMethod(widget.url, widget.videoId, widget.videoName);
  }

  @override
  void dispose() {
    Get.delete<YoutubePlayerCustomCntroller>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: _youtubeVideoPlayer(),
      builder: (context, player) {
        return SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              player,
            ],
          ),
        );
      },
    );
  }

  Widget _youtubeVideoPlayer() {
    return YoutubePlayer(
      onEnded: (data) {
        customController?.youPlayerController?.pause();
        _playNextVideo();
      },
      controller: customController?.youPlayerController,
      showVideoProgressIndicator: true,
      progressColors: ProgressBarColors(
        playedColor: Colors.redAccent,
        handleColor: Colors.red,
      ),
    );
  }

  void _playNextVideo() async {
    VideoDetailsViewModel videoDetailsController = Get.find();
    var youtubePlayerCustomController = Get.put(YoutubePlayerCustomCntroller());
    var videoVIewController = Get.put(VideoViewViewModel());
    FavoriteViewModel favViewModel = Get.put(FavoriteViewModel());

    /// save last played video as played
    SimilarToThisVideoListTraker.playedSimilarVideos
        .add(videoDetailsController?.initialData?.value?.id ?? 0);

    if (videoDetailsController?.categoryMaylikeModel?.data?.isEmpty ?? null) {
      return;
    }

    HomeData homeData = videoDetailsController?.categoryMaylikeModel?.data[0];

    /// check whether this video is premium or not
    /// and take decision based on it
    if(homeData.isPremium == 1){
      /// if user not a premium user then do nothing
      if (PremiumVideoServices.userIsAPremiumUser() == false){
        return;
      }
    }

    videoDetailsController.refreshData(homeData);

    videoVIewController.model.value = null;
    videoVIewController.model.value = homeData;
    String strUrl = homeData.videoUrl;
    String videoId = homeData.id?.toString();
    String videoName = homeData?.title;

    /// call is favorite method to check the video is in fav list or not
    favViewModel.setFavorite(int.parse(videoId));

    if (!strUrl.contains('youtube') && !strUrl.contains('vimeo')) {
      AppPlayerController appPlayerController = Get.put(AppPlayerController());

      /// save last played video info
      ///await appPlayerController?.saveLastPlayedVideoInfo();

      /// play new video
      appPlayerController?.initBetterPlayerController(
          strUrl, videoId, videoName);
    } else {
      /// save last played video info
      ///await youtubePlayerCustomController?.saveLastPlayedVideoInfo();

      /// update youtube player video source with new video
      youtubePlayerCustomController.playMethod(strUrl, videoId, videoName);

      ///call video view count api
      videoVIewController.historyAddMethod(homeData?.id.toString());
    }
  }
}

class YoutubePlayerCustomCntroller extends GetxController {
  YoutubePlayerController youPlayerController;

  String vUrl;
  String id;
  String name;

  playMethod(String url, String vId, String videoName) {
    vUrl = url;
    id = vId;
    name = videoName;

    int startAt = PlayFromController.playFrom;
    PlayFromController.playFrom = 0;

    String videoId;
    try {
      videoId = YoutubePlayer.convertUrlToId(url);
      youPlayerController = YoutubePlayerController(
        initialVideoId: '$videoId',
        flags: YoutubePlayerFlags(
          /// i con play video from a specific position
          startAt: startAt,
          autoPlay: true,
        ),
      );
      youPlayerController.addListener(() {});
    } catch (e, t) {
      print(e);
      print(t);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    int playedTill = youPlayerController?.value?.position?.inSeconds;
    int totalDuration =
        youPlayerController?.value?.metaData?.duration?.inSeconds;

    if (id != null && playedTill != null && totalDuration != null) {
      KeepWatchingController keepWatchingController =
          Get.put(KeepWatchingController());
      keepWatchingController.addToKeepWatchingQueue(
          videoId: id, playedTill: playedTill, totalDuration: totalDuration);
    }
    super.onClose();
  }

  Future<void> saveLastPlayedVideoInfo() async {
    int playedTill = youPlayerController?.value?.position?.inSeconds;
    int totalDuration =
        youPlayerController?.value?.metaData?.duration?.inSeconds;

    if (id != null && playedTill != null && totalDuration != null) {
      KeepWatchingController keepWatchingController =
          Get.put(KeepWatchingController());
      keepWatchingController.addToKeepWatchingQueue(
          videoId: id, playedTill: playedTill, totalDuration: totalDuration);
    }
  }
}

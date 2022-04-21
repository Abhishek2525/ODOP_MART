import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iotflixcinema/core/downloader/app_dowbloader.dart';
import 'package:iotflixcinema/core/services/premium_video_services.dart';

import '../../../view/pages/video_details/vedio_player/youtube_player.dart';
import '../../controllers/similar_to_this_video_list_traker.dart';
import '../../models/home_categories_model.dart';
import '../VideoDetailsViewModel.dart';
import '../fevorite_view_model.dart';
import '../keep_watching_controller.dart';
import '../play_from_controller.dart';
import '../video_view_view_model.dart';

/// A [Get] Controller to control Video Player
class AppPlayerController extends GetxController {
  BetterPlayerController betterPlayerController;

  String vUrl;
  String vId;
  String vName;

  @override
  void onInit() {
    super.onInit();
  }

  /// return vimeo platform's video ID from Vimeo video url
  String getVimoId(String url) {
    String id = url.split('/').last;
    return id;
  }

  /// Check Whether a video is from [Vimeo] Platform or not from its URl
  isVimoUrl(String url) {
    return url.contains('vimeo.com/');
  }

  Future<String> idVimoVideo(String url) async {
    http.Response response = await http.get(Uri.parse(
        'https://player.vimeo.com/video/' + getVimoId(url) + '/config'));
    var jsonData = jsonDecode(response.body)['request']['files']['progressive'];

    if (jsonData is List) {
      if (jsonData.length > 0) {
        return jsonData.last['url'];
      }
    }

    return null;
  }

  int backGroundCallBack = 0;

  /// Initialize [BetterPlayerController] with data source
  /// And configure the [BetterPlayerController]
  void initBetterPlayerController(
      String videoUrl, String videoId, String videoName) async {
    vUrl = videoUrl;
    vId = videoId;
    vName = videoName;
    bool localPath = false;
    print("player path : => $vUrl");

    if (!videoUrl.startsWith('http')) {
      try {
        bool b = await File(videoUrl).exists();

        print("video play from local path");
        if (b == true) {
          bool isRunning = await FlutterBackgroundService().isServiceRunning();
          if (!isRunning) {
            await FlutterBackgroundService.initialize(onStart);
          }
          FlutterBackgroundService().sendData(
            {
              "action": "decrypt",
              "videoPath": videoUrl,
            },
          );
          FlutterBackgroundService().onDataReceived.listen(
            (event) async {
              if (event['decryptComplete'] == true) {
                print("decrypt callback : $event");
                print(event['video'].runtimeType);
                String video = event['video']?.toString();

                if (video == null || video?.length == 0) return;
                vUrl = video;

                BetterPlayerDataSource s = BetterPlayerDataSource.file(
                  video,
                  cacheConfiguration:
                      BetterPlayerCacheConfiguration(useCache: false),
                );

                if (backGroundCallBack == 0) {
                  controllerInit(s);
                }
                backGroundCallBack++;
              }
            },
          );

          localPath = true;
          return;
        }
      } catch (e) {
        return;
      }
      return;
    }

    /// do video url specific related works
    if (videoUrl.contains('https:')) {
      videoUrl = videoUrl;
    } else {
      videoUrl = videoUrl.replaceFirst('http:', 'https:');
    }

    if (isVimoUrl(videoUrl)) {
      String url = await idVimoVideo(videoUrl);
      videoUrl = url != null ? url : videoUrl;
      //print("vimo url:-> $videoUrl");
    }
    BetterPlayerDataSource source = localPath == true
        ? BetterPlayerDataSource.file(videoUrl,
            cacheConfiguration: BetterPlayerCacheConfiguration(useCache: false))
        : BetterPlayerDataSource.network(videoUrl);

    controllerInit(source);
  }

  controllerInit(BetterPlayerDataSource source) {
    print("controllerInit $backGroundCallBack");

    /// Check If the video playing from keep watching list
    ///
    /// We need to play from specific position that was previously played
    int startAt = PlayFromController.playFrom;
    PlayFromController.playFrom = 0;

    /// Initialize the Better Player Controller and set the Data Source

    betterPlayerController = null;
    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        autoDispose: true,
        handleLifecycle: true,
        startAt: Duration(seconds: startAt),
      ),
      betterPlayerDataSource: source,
    );

    update();
    betterPlayerController.play();

    /// Track the Better player event and play next video current video is finished
    betterPlayerController.addEventsListener((event) async {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        _playNextVideo();
      }
    });
  }

  @override
  void onClose() {
    /// Save the video as keep watching if user stop watching
    /// the current video before finishing it
    /// dispose encrypted video

    betterPlayerController?.pause();
    int playedTill = betterPlayerController
        ?.videoPlayerController?.value?.position?.inSeconds;
    int totalDuration = betterPlayerController
        ?.videoPlayerController?.value?.duration?.inSeconds;

    if (vId != null && playedTill != null && totalDuration != null) {
      KeepWatchingController keepWatchingController =
          Get.put(KeepWatchingController());
      keepWatchingController.addToKeepWatchingQueue(
          videoId: vId, playedTill: playedTill, totalDuration: totalDuration);
    }
    betterPlayerController?.dispose(forceDispose: true);

    AppDownloader.getInstance.onPlayerDispose(vUrl);
    super.onClose();
  }

  /// Save the video as keep watching if user stop watching
  /// the current video before finishing it
  Future<void> saveLastPlayedVideoInfo() async {
    try {
      int playedTill = betterPlayerController
          ?.videoPlayerController?.value?.position?.inSeconds;
      int totalDuration = betterPlayerController
          ?.videoPlayerController?.value?.duration?.inSeconds;

      if (vId != null && playedTill != null && totalDuration != null) {
        KeepWatchingController keepWatchingController =
            Get.put(KeepWatchingController());
        keepWatchingController.addToKeepWatchingQueue(
            videoId: vId, playedTill: playedTill, totalDuration: totalDuration);
      }
    } catch (e) {}
  }

  /// This method plays the first video from the [KeepWatchingVideos] list
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

    String strUrl = homeData?.videoUrl;
    String videoId = homeData?.id?.toString();
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

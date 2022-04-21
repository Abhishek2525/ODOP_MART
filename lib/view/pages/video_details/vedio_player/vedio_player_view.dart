
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/home_categories_model.dart';
import '../../../../core/view_models/video_player_controllers/app_player_controller.dart';
import '../../../../core/view_models/video_view_view_model.dart';
import 'app_player.dart';
import 'youtube_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String thumbnailUrl;

  // final String videoUrl;
  final int nestedId;
  final HomeData model;

  VideoPlayerView({
    this.thumbnailUrl,
    // this.videoUrl,
    this.nestedId,
    this.model,
  }) {
    var videoViewModel = Get.put(VideoViewViewModel());
    videoViewModel.setModel(model);
  }

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  _VideoPlayerViewState();

  Widget playerView;

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> getVideoPlayer(
      String videoUrl, String videoId, String videoName) async {


    if ((videoUrl?.contains("youtube") ?? false)) {
      return Column(
        children: [
          YoutubePlayerView(videoUrl, videoId, videoName),
          SizedBox(
            height: 10,
          ),
        ],
      );
    } else {
      Get.put(AppPlayerController());
      return AppPlayer(videoUrl, videoId, videoName);
    }
  }

  @override
  void dispose() {
    Get.delete<AppPlayerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoViewViewModel>(
      builder: (c) {
        String videoUrl = c.model?.value?.videoUrl;
        String videoId = c.model?.value?.id?.toString();
        String videoName = c.model?.value?.title;
        return FutureBuilder<Widget>(
          future: getVideoPlayer(videoUrl, videoId, videoName),
          builder: (_, snap) {
            if (snap.hasData)
              return snap.data;
            else
              return Container();
          },
        );
      },
    );
  }
}

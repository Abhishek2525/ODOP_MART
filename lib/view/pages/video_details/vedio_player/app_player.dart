import 'package:flutter/material.dart';

import 'package:better_player/better_player.dart';
import 'package:get/get.dart';

import '../../../../core/view_models/video_player_controllers/app_player_controller.dart';

class AppPlayer extends StatefulWidget {
  final String url;
  final String videoId;
  final String videoName;

  AppPlayer(this.url, this.videoId, this.videoName);

  @override
  _AppPlayerState createState() => _AppPlayerState();
}

class _AppPlayerState extends State<AppPlayer> {
  AppPlayerController appPlayerController = Get.find();

  @override
  void initState() {
    super.initState();

    print("played from AppPlayer ${widget.url}");

    appPlayerController.initBetterPlayerController(
        widget.url, widget.videoId, widget.videoName);
  }

  @override
  void dispose() {
    Get.delete<AppPlayerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppPlayerController>(
      builder: (c) => appPlayerController?.betterPlayerController != null
          ? BetterPlayer(

              controller: appPlayerController?.betterPlayerController)
          : AspectRatio(
              aspectRatio: 16 / 8,
              child: Container(
                color: Colors.black,
              ),
            ),
    );
  }
}

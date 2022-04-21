import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';

import '../../../core/models/home_categories_model.dart';
import '../../../core/models/tv_channel.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../video_details/vedio_player/vedio_player_view.dart';

// ignore: must_be_immutable
class WatchTvPage extends StatefulWidget {
  TvChannel channel;

  WatchTvPage(this.channel);

  @override
  _WatchTvPageState createState() => _WatchTvPageState();
}

class _WatchTvPageState extends State<WatchTvPage> {
  Function wp;
  Function hp;

  Color themeSpecificColor;

  String _appBarTitle;

  VideoModel videoModel;

  @override
  void initState() {
    super.initState();

    videoModel = VideoModel(
        videoUrl: widget.channel?.streamUrl,
        id: -1,
        title: widget.channel?.name);

    _appBarTitle = widget.channel.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return SafeArea(
      child: Scaffold(
        appBar: IotaAppBar.appBarWithTitle(
          title: _appBarTitle,
          backButtonOnTap: () {
            AppRouter.back();
          },
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        themeSpecificColor = themeController.themeMode == ThemeMode.dark
            ? AppColors.white
            : AppColors.black;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VideoPlayerView(
                model: videoModel,
                thumbnailUrl: widget.channel?.img ?? '',
                //videoUrl: widget.channel?.streamUrl ?? '',
              ),
            ],
          ),
        );
      },
    );
  }
}

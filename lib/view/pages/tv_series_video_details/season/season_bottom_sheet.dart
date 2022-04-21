import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../core/models/tv_series_seasons_model.dart';
import '../../../../core/view_models/tv_series_view_model.dart';
import '../../../../core/view_models/video_player_controllers/app_player_controller.dart';
import '../../../../core/view_models/video_view_view_model.dart';
import '../../../constant/app_colors.dart';
import '../../saiful_tv_series_pages/saiful_tv_series_details_view_model.dart';
import '../../video_details/vedio_player/youtube_player.dart';

bool disableEpisode = true;

class BottomSheetSeason {
  static bottomSheetPro({
    BuildContext context,
    List<Seasons> seasons,
  }) async {
    showModalBottomSheet(
      backgroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return BottomSheetWidget(seasons);
      },
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  final List<Seasons> seasons;

  BottomSheetWidget(this.seasons);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  TvSeriesViewModel tvSeriesController = Get.put(TvSeriesViewModel());
  var youtubePlayerCustomController = Get.put(YoutubePlayerCustomCntroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaifulTvSeriesDetailsViewModel>(
      builder: (controller) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  spreadRadius: .1,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                  color: AppColors.shadowRed.withOpacity(.3),
                )
              ]),
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Text(
                "Select Season here",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.headline1.color,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget?.seasons?.length ?? 0,
                    itemBuilder: (BuildContext context, index) {
                      return InkWell(
                        onTap: () {
                          controller.episodesList.value =
                              widget.seasons[index]?.episodes;
                          controller.seasonNumber.value =
                              widget.seasons[index]?.id?.toString();
                          if (widget.seasons[index].episodes.isNotEmpty) {
                            controller.refreshData(
                              widget.seasons[index]?.episodes?.first,
                            );

                            var videoVIewController =
                                Get.put(VideoViewViewModel());
                            videoVIewController.model.value = null;
                            videoVIewController.model.value =
                                controller?.episodesList?.first;

                            String strUrl =
                                controller?.episodesList?.first?.videoUrl;
                            String videoId =
                                controller?.episodesList?.first?.id?.toString();
                            String videoName =
                                controller?.episodesList?.first?.title;

                            if (!strUrl.contains('youtube') &&
                                !strUrl.contains('vimeo')) {
                              AppPlayerController appPlayerController =
                                  Get.put(AppPlayerController());
                              appPlayerController?.initBetterPlayerController(
                                  strUrl, videoId, videoName);
                            }

                            youtubePlayerCustomController.playMethod(
                                strUrl, videoId, videoName);
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                (index < 9)
                                    ? '0' + widget.seasons[index].id.toString()
                                    : widget.seasons[index].id.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: AppColors.shadowRed.withOpacity(.2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}

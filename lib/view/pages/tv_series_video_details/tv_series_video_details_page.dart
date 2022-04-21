import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/models/tv_series_seasons_model.dart';
import '../../../core/utils/local_auth/local_auth_get_storage.dart';
import '../../../core/utils/toast/flutter_toast.dart';
import '../../../core/view_models/VideoDetailsViewModel.dart';
import '../../../core/view_models/fevorite_view_model.dart';
import '../../../core/view_models/reports_view_model.dart';
import '../../../core/view_models/tv_series_view_model.dart';
import '../../../core/view_models/video_player_controllers/app_player_controller.dart';
import '../../../core/view_models/video_view_view_model.dart';
import '../../cards/cast/cast_car_tv_series.dart';
import '../../constant/app_colors.dart';
import '../../custom/read_more/read_more.dart';
import '../../router/app_router.dart';
import '../../widgets/round_border_button.dart';
import '../video_details/vedio_player/vedio_player_view.dart';
import '../video_details/vedio_player/youtube_player.dart';
import 'season/episod_bottom_sheet.dart';
import 'season/season_bottom_sheet.dart';
import 'season_video_card.dart';
import 'tv_series_info_card.dart';

class TvSeriesVideoDetailsPage extends StatefulWidget {
  final Episodes episodes;
  final String seriesName;
  final String seasonTitle;
  final int nestedId;

  TvSeriesVideoDetailsPage(
      {this.episodes, this.seriesName, this.seasonTitle, this.nestedId});

  @override
  _TvSeriesVideoDetailsPageState createState() =>
      _TvSeriesVideoDetailsPageState();
}

class _TvSeriesVideoDetailsPageState extends State<TvSeriesVideoDetailsPage> {
  String dropdownValue = '01';
  double _animatedHeight = 0;
  bool makeReport = false;
  TextEditingController reportText = TextEditingController();
  TvSeriesViewModel tvSeriesController = Get.put(TvSeriesViewModel());

  var youtubePlayerCustomController = Get.put(YoutubePlayerCustomCntroller());

  @override
  void initState() {
    super.initState();
    disableEpisode = true;
    episodeNo = "--";
    tvSeriesController.setInitialData(widget.episodes);
    tvSeriesController.getTvSeriesSeasonEpisodeMethode(
        type: "normal",
        seasonid: widget.episodes.tvSeriesSeasonId,
        episode: widget.episodes.tvSeriesEpisodeNo);
  }

  @override
  void dispose() {
    super.dispose();
    reportText.dispose();
  }

  String editableText;

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(MediaQuery.of(context).size).wp;
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (tvSeriesController.initialData.value != null) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Obx(() {
                          if (tvSeriesController.initialDataLoading.value ==
                              true) {
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          } else {
                            return VideoPlayerView(
                              nestedId: widget?.nestedId,
                              model: widget?.episodes,
                              thumbnailUrl: (widget?.episodes?.thumbnail == null
                                  ? 'https://picsum.photos/90'
                                  : AppUrls.imageBaseUrl +
                                      widget?.episodes?.thumbnail),
                            );
                          }
                        }),
                        InkWell(
                          onTap: () {
                            AppRouter.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 30),
                            child: ImageIcon(
                              AssetImage('images/backIcon.png'),
                              size: 20,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: Column(
                        children: [
                          GetBuilder<VideoDetailsViewModel>(
                            builder: (videoDetailsController) =>
                                TvSeriesInfoCard(
                              imgPath: widget?.episodes?.thumbnail == null
                                  ? "https://picsum.photos/60"
                                  : AppUrls.imageBaseUrl +
                                      widget?.episodes?.thumbnail,
                              movieName:
                                  '${widget?.seriesName} | ${widget?.seasonTitle}',
                              episodeTitle: widget?.episodes?.title,
                              movieType: 'TV-Series',
                              language: 'Spanish',
                              resolution: videoDetailsController
                                  ?.videoDetailsModel
                                  ?.value
                                  ?.data
                                  ?.video
                                  ?.videoResolution
                                  ?.name,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ReadMoreText(
                              widget?.episodes?.description ??
                                  "About this Episode",
                              textStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GetBuilder<VideoDetailsViewModel>(
                            builder: (videoDetailsController) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          makeReport = !makeReport;
                                          makeReport
                                              ? _animatedHeight = 165.0
                                              : _animatedHeight = 0;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          ImageIcon(
                                            AssetImage('images/reportVid.png'),
                                            color: makeReport
                                                ? AppColors.shadowRed
                                                : AppColors.borderColor,
                                            size: 22,
                                          ),
                                          Text(
                                            'Report',
                                            style: TextStyle(
                                                color: makeReport
                                                    ? AppColors.shadowRed
                                                    : AppColors.borderColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Share.share(
                                            'This Movie is awesome!. ${videoDetailsController.initialData.value.videoUrl}');
                                      },
                                      child: Column(
                                        children: [
                                          ImageIcon(
                                            AssetImage('images/shareIcon.png'),
                                            color: AppColors.borderColor,
                                            size: 22,
                                          ),
                                          Text(
                                            'Share',
                                            style: TextStyle(
                                                color: AppColors.borderColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: GetBuilder<FavoriteViewModel>(
                                      builder: (c) {
                                        c?.setFavorite(widget.episodes.id);
                                        return GestureDetector(
                                          onTap: () {
                                            if (c.isFavorite.value == false) {
                                              c.addFavoriteData(
                                                widget.episodes.id.toString(),
                                                context,
                                              );
                                            } else {
                                              c.deleteFavoriteData(widget
                                                  .episodes.id
                                                  ?.toString());
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              ImageIcon(
                                                AssetImage(
                                                    'images/loveIcon.png'),
                                                color:
                                                    c?.isFavorite?.value == true
                                                        ? AppColors.red
                                                        : AppColors.borderColor,
                                                size: 22,
                                              ),
                                              Text(
                                                'Favorite',
                                                style: TextStyle(
                                                    color: c.isFavorite.value ==
                                                            true
                                                        ? AppColors.red
                                                        : AppColors.borderColor,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: LocalDBUtils.getJWTToken() == null
                                          ? () {}
                                          : () async {
                                              videoDetailsController
                                                  .getLikeVideoMethod(
                                                videoId: videoDetailsController
                                                    ?.initialData?.value?.id,
                                                currentStatus:
                                                    videoDetailsController
                                                        ?.initialData
                                                        ?.value
                                                        ?.like,
                                              );
                                            },
                                      child: Column(
                                        children: [
                                          ImageIcon(
                                            AssetImage('images/likeIcon.png'),
                                            color: videoDetailsController
                                                        ?.videoDetailsModel
                                                        ?.value
                                                        ?.data
                                                        ?.video
                                                        ?.userLike ==
                                                    1
                                                ? AppColors.red
                                                : AppColors.borderColor,
                                            size: 22,
                                          ),
                                          Text(
                                            videoDetailsController
                                                    ?.videoDetailsModel
                                                    ?.value
                                                    ?.data
                                                    ?.video
                                                    ?.like
                                                    ?.toString() ??
                                                "0",
                                            style: TextStyle(
                                                color: videoDetailsController
                                                            ?.videoDetailsModel
                                                            ?.value
                                                            ?.data
                                                            ?.video
                                                            ?.userLike ==
                                                        1
                                                    ? AppColors.red
                                                    : AppColors.borderColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  /// unlike widget
                                  Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: LocalDBUtils.getJWTToken() == null
                                          ? () {}
                                          : () async {
                                              videoDetailsController
                                                  .getDislikeVideoMethod(
                                                videoId: videoDetailsController
                                                    ?.initialData?.value?.id,
                                                currentStatus:
                                                    videoDetailsController
                                                        ?.initialData
                                                        ?.value
                                                        ?.dislike,
                                              );
                                            },
                                      child: Column(
                                        children: [
                                          ImageIcon(
                                            AssetImage(
                                                'images/dislikeIcon.png'),
                                            color: videoDetailsController
                                                        ?.videoDetailsModel
                                                        ?.value
                                                        ?.data
                                                        ?.video
                                                        ?.userDislike ==
                                                    1
                                                ? AppColors.red
                                                : AppColors.borderColor,
                                            size: 22,
                                          ),
                                          Text(
                                            videoDetailsController
                                                    ?.videoDetailsModel
                                                    ?.value
                                                    ?.data
                                                    ?.video
                                                    ?.dislike
                                                    ?.toString() ??
                                                "0",
                                            style: TextStyle(
                                                color: videoDetailsController
                                                            ?.videoDetailsModel
                                                            ?.value
                                                            ?.data
                                                            ?.video
                                                            ?.userDislike ==
                                                        1
                                                    ? AppColors.red
                                                    : AppColors.borderColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 5,
                            thickness: .5,
                            color: AppColors.dividerColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            height: _animatedHeight,
                            child: GetBuilder<ReportsViewModel>(
                              builder: (controller) => SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      'Let us know if you having issue with watching video',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline4
                                            .color,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          border: Border.all(
                                              color:
                                                  AppColors.searchBorderColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              cursorColor:
                                                  AppColors.textFieldTextColor,
                                              maxLines: 2,
                                              controller: reportText,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: AppColors
                                                      .textFieldTextColor,
                                                  fontWeight: FontWeight.bold),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.only(
                                                    left: 20,
                                                    top: 0,
                                                    bottom: 8),
                                                hintText: 'Report details here',
                                                hintStyle: TextStyle(
                                                    fontSize: 9,
                                                    color: AppColors
                                                        .textFieldTextColor,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: wp(80),
                                      child: RoundBoarderButton(
                                        text: 'SUBMIT',
                                        padding: 0,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 4),
                                        onPress: () async {
                                          if (reportText.text != null &&
                                              reportText.text != '') {
                                            await controller
                                                .getAddReportsMethod(
                                                    id: widget.episodes.id
                                                        .toString(),
                                                    description:
                                                        reportText.text);
                                            if (controller
                                                    .addReportsModel.status ==
                                                true) {
                                              FlutterToast.showSuccess(
                                                  message:
                                                      "Reported Successfully",
                                                  context: context);
                                            }
                                          }

                                          setState(() {
                                            reportText.clear();
                                            _animatedHeight = 0;
                                            makeReport = false;
                                          });
                                        },
                                      ),
                                    ),
                                    Divider(
                                      height: 5,
                                      thickness: .5,
                                      color: AppColors.dividerColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Episode Video',
                              style: TextStyle(
                                fontFamily: 'poppins_bold',
                                fontSize: 14,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Season: ',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline1
                                                    .color,
                                              ),
                                            ),
                                            Text(
                                              tvSeriesController
                                                          .tvSeriesSeasonEpisodeModel
                                                          .value
                                                          .data ==
                                                      null
                                                  ? "--"
                                                  : tvSeriesController
                                                          ?.tvSeriesSeasonEpisodeModel
                                                          ?.value
                                                          ?.data
                                                          ?.first
                                                          ?.id
                                                          .toString() ??
                                                      "0",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.shadowRed,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: AppColors.shadowRed,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  AbsorbPointer(
                                    absorbing: disableEpisode,
                                    child: GestureDetector(
                                      onTap: () {
                                        BottomSheetEpisode.bottomSheetPro(
                                          context: context,
                                          episodes: tvSeriesController
                                                  ?.tvSeriesSeasonsModel
                                                  ?.value
                                                  ?.data
                                                  ?.seasons[tvSeriesController
                                                          .tvSeriesSeasonEpisodeModel
                                                          .value
                                                          .data
                                                          .first
                                                          .id -
                                                      1]
                                                  ?.episodes ??
                                              "--",
                                        );
                                      },
                                      child: Container(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Episode: ',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .headline1
                                                      .color,
                                                ),
                                              ),
                                              Text(
                                                episodeNo,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.shadowRed,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: AppColors.shadowRed,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, top: 10, bottom: 5),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Color(0xffE15050)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          GetBuilder<VideoDetailsViewModel>(
                              builder: (videoDetailsController) {
                            List<Episodes> episodsList = tvSeriesController
                                ?.tvSeriesSeasonEpisodeModel
                                ?.value
                                ?.data
                                ?.first
                                ?.episodes;
                            return Container(
                              height: wp(50) * (4 / 5),
                              child: ListView.builder(
                                padding: EdgeInsets.all(10),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: episodsList?.length ?? 0,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        SeasonVideoCard(
                                  index:
                                      episodsList[index].tvSeriesEpisodeNo ?? 0,
                                  title: episodsList[index]?.title ?? " Title",
                                  imgPath: episodsList[index]?.thumbnail,
                                  onTap: () {
                                    _similarOntap(videoDetailsController,
                                        episodsList[index]);
                                    tvSeriesController
                                        .setInitialData(episodsList[index]);
                                  },
                                ),
                              ),
                            );
                          }),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 8,
                            thickness: .5,
                            color: AppColors.dividerColor,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CastCardTvSeries(
                            actors: widget.episodes.actors,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        }),
      ),
    );
  }

  /// this method is called when tapping any item from similar videos
  void _similarOntap(var videoDetailsController, Episodes newVideo) {
    videoDetailsController.refreshData(newVideo);

    var videoVIewController = Get.put(VideoViewViewModel());
    videoVIewController.model.value = null;
    videoVIewController.model.value = newVideo;

    String strUrl = newVideo?.videoUrl;
    String videoId = newVideo?.id?.toString();
    String videoName = newVideo?.title;

    if (!strUrl.contains('youtube') && !strUrl.contains('vimeo')) {
      AppPlayerController appPlayerController = Get.put(AppPlayerController());
      appPlayerController?.initBetterPlayerController(
          strUrl, videoId, videoName);
    }

    youtubePlayerCustomController.playMethod(strUrl, videoId, videoName);
  }
}

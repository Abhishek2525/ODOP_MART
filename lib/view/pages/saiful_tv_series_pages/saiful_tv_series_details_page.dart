import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:iotflixcinema/core/models/home_categories_model.dart';
import 'package:iotflixcinema/core/services/premium_video_services.dart';
import 'package:share/share.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/middle_ware/route_objerver.dart';
import '../../../core/utils/local_auth/local_auth_get_storage.dart';
import '../../../core/utils/toast/flutter_toast.dart';
import '../../../core/view_models/categories_view_model.dart';
import '../../../core/view_models/fevorite_view_model.dart';
import '../../../core/view_models/reports_view_model.dart';
import '../../../core/view_models/video_player_controllers/app_player_controller.dart';
import '../../../core/view_models/video_view_view_model.dart';
import '../../cards/cast/cast_card.dart';
import '../../constant/app_colors.dart';
import '../../custom/read_more/read_more.dart';
import '../../router/app_router.dart';
import '../../widgets/dialogs/simple_info_dialog.dart';
import '../../widgets/round_border_button.dart';
import '../../widgets/shimmers/video_details_shimmer.dart';
import '../signin_page/Sign_In_Page.dart';
import '../tv_series_video_details/season/season_bottom_sheet.dart';
import '../video_details/similar_img_card.dart';
import '../video_details/vedio_player/vedio_player_view.dart';
import '../video_details/vedio_player/youtube_player.dart';
import '../video_details/video_details_info_card.dart';
import 'saiful_tv_series_details_view_model.dart';

class SaifulTvSeriesDetailsPage extends StatefulWidget {
  final int nestedId;
  final int catId;
  final int videoId;

  SaifulTvSeriesDetailsPage({this.nestedId, this.catId, this.videoId});

  @override
  _SaifulTvSeriesDetailsPageState createState() =>
      _SaifulTvSeriesDetailsPageState();
}

class _SaifulTvSeriesDetailsPageState extends State<SaifulTvSeriesDetailsPage> {
  Function wp;
  Function hp;

  double _animatedHeight = 0;
  bool makeReport = false;
  TextEditingController reportText = TextEditingController();

  var youtubePlayerCustomController = Get.put(YoutubePlayerCustomCntroller());

  var videoVIewController = Get.put(VideoViewViewModel());

  @override
  void dispose() {
    super.dispose();
    reportText.text;
  }

  CategoriesViewModel catModel = Get.put(CategoriesViewModel());

  @override
  void initState() {
    super.initState();

    /// call api for video view count and add to history
    videoVIewController.historyAddMethod(widget.videoId.toString());
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      body: GetBuilder<SaifulTvSeriesDetailsViewModel>(
        builder: (videoDetailsController) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// The video player widget
                  (videoDetailsController.loadingVideo.value == false &&
                          videoDetailsController.initialData.value != null)
                      ? _videoPlayerAndAppBar(videoDetailsController)
                      : Center(
                          child: CupertinoActivityIndicator(),
                        ),

                  _videoDetailsWidget(videoDetailsController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// returns a widget that contains the video player and the appbar
  Widget _videoPlayerAndAppBar(
      SaifulTvSeriesDetailsViewModel videoDetailsController) {
    return Stack(
      children: [
        VideoPlayerView(
          nestedId: widget?.nestedId,
          model: videoDetailsController?.initialData?.value,
          thumbnailUrl:
              (videoDetailsController?.initialData?.value?.thumbnail == null
                  ? 'https://picsum.photos/90'
                  : AppUrls.imageBaseUrl +
                      videoDetailsController?.initialData?.value?.thumbnail),
        ),
        InkWell(
          onTap: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
            Get.back();
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
    );
  }

  /// this method returns a widget that contains action panel of the video (like, report, dislike, share)
  Widget _getActionsWidget(
      SaifulTvSeriesDetailsViewModel videoDetailsController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  makeReport = !makeReport;
                  makeReport ? _animatedHeight = 165.0 : _animatedHeight = 0;
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
                youtubePlayerCustomController?.youPlayerController?.pause();
                Share.share('Hey! check out this awesome video. ' +
                    AppUrls.deepLinkingBaseUrl +
                    videoDetailsController.initialData.value.id.toString());
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
                c?.setFavorite(videoDetailsController?.initialData?.value?.id);
                return GestureDetector(
                  onTap: (LocalDBUtils.getJWTToken() == null)
                      ? _handleUnAuthenticateduser
                      : () {
                          if (c.isFavorite.value == false) {
                            c.addFavoriteData(
                              videoDetailsController?.initialData?.value?.id
                                  ?.toString(),
                              context,
                            );
                          } else {
                            c.deleteFavoriteData(videoDetailsController
                                ?.initialData?.value?.id
                                ?.toString());
                          }
                        },
                  child: Column(
                    children: [
                      ImageIcon(
                        AssetImage('images/loveIcon.png'),
                        color: c?.isFavorite?.value == true
                            ? AppColors.red
                            : AppColors.borderColor,
                        size: 22,
                      ),
                      Text(
                        'Favorite',
                        style: TextStyle(
                            color: c.isFavorite?.value == true
                                ? AppColors.red
                                : AppColors.borderColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          /// like widget
          Expanded(
            flex: 1,
            child: Obx((){
              return InkResponse(
                onTap: (LocalDBUtils.getJWTToken() == null)
                    ? _handleUnAuthenticateduser
                    : () async {
                  int videoId =
                      videoDetailsController?.initialData?.value?.id;
                  int currentStatus = videoDetailsController
                      ?.videoDetailsModel?.value?.data?.video?.userLike;
                  videoDetailsController.getLikeVideoMethod(
                    videoId: videoId,
                    currentStatus: currentStatus,
                  );
                  /// like
                  videoDetailsController.newPerformLike();
                },
                child: Column(
                  children: [
                    ImageIcon(
                      AssetImage('images/likeIcon.png'),
                      color: videoDetailsController.liked.value
                          ? AppColors.red
                          : AppColors.borderColor,
                      size: 22,
                    ),
                    Text(
                      videoDetailsController
                          ?.initialData?.value?.like?.toString() ??
                          "0",
                      style: TextStyle(
                          color: videoDetailsController.liked.value
                              ? AppColors.red
                              : AppColors.borderColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              );
            }),
          ),

          /// unlike widget
          Expanded(
            flex: 1,
            child: Obx((){
              return InkResponse(
                onTap: (LocalDBUtils.getJWTToken() == null)
                    ? _handleUnAuthenticateduser
                    : () async {
                  int videoId =
                      videoDetailsController?.initialData?.value?.id;
                  int currentStatus = videoDetailsController
                      ?.videoDetailsModel?.value?.data?.video?.userDislike;
                  videoDetailsController.getDislikeVideoMethod(
                    videoId: videoId,
                    currentStatus: currentStatus,
                  );
                  /// unlike
                  videoDetailsController.newPerformUnlike();
                },
                child: Column(
                  children: [
                    ImageIcon(
                      AssetImage('images/dislikeIcon.png'),
                      color: videoDetailsController.unLiked.value
                          ? AppColors.red
                          : AppColors.borderColor,
                      size: 22,
                    ),
                    Text(
                      videoDetailsController?.initialData?.value?.dislike.toString() ??
                          "0",
                      style: TextStyle(
                          color: videoDetailsController.unLiked.value
                              ? AppColors.red
                              : AppColors.borderColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// show a dialog if non signed user trying to like or dislike a video and
  /// navigate them to login screen
  void _handleUnAuthenticateduser() {
    showSimpleInfoDialog(
        onLoginPresed: () {
          youtubePlayerCustomController?.youPlayerController?.pause();
          Get.back();
          Get.to(() => SignInPage());
        },
        message: 'You are not logged in.\nPlease login to continue.');
  }

  /// this method is called when tapping any item from similar videos
  void _similarOnTap(
      SaifulTvSeriesDetailsViewModel videoDetailsController, int index) {

    HomeData homeData = videoDetailsController?.episodesList[index];

    /// handle premium video
    bool isPremium = homeData.isPremium == 1 ? true: false;
    if(isPremium){
      try{
        YoutubePlayerCustomCntroller ytc = Get.find();
        ytc?.youPlayerController?.pause();
        AppPlayerController appPlayerController = Get.find();
        appPlayerController?.betterPlayerController?.pause();
      }
      catch(err){
        print('$err');
      }
      if(PremiumVideoServices.userIsAPremiumUser() == false){
        return;
      }
    }

    videoDetailsController.refreshData(
      homeData,
    );

    videoVIewController.model.value = null;
    videoVIewController.model.value =
        homeData;

    String strUrl = homeData?.videoUrl;
    String videoId =
        homeData?.id?.toString();
    String videoName = homeData?.title;

    if (!strUrl.contains('youtube') && !strUrl.contains('vimeo')) {
      AppPlayerController appPlayerController = Get.put(AppPlayerController());
      appPlayerController?.initBetterPlayerController(
          strUrl, videoId, videoName);
    }

    youtubePlayerCustomController.playMethod(strUrl, videoId, videoName);

    /// call view count api
    videoVIewController.historyAddMethod(
        homeData?.id?.toString());
  }

  Widget _videoDetailsWidget(
      SaifulTvSeriesDetailsViewModel videoDetailsController) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),

        /// The video details widget
        /// Similar video widget
        /// Actors Widget
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: Column(
            children: [
              SizedBox(height: 10),
              (videoDetailsController.loadingDetails.value == false &&
                      videoDetailsController.videoDetailsModel.value != null)
                  ? Column(
                      children: [
                        /// video details widget
                        VideoDetailsInfoCard(
                          imgPath: (videoDetailsController
                                      ?.initialData?.value?.thumbnail ==
                                  null
                              ? 'https://picsum.photos/90'
                              : AppUrls.imageBaseUrl +
                                  videoDetailsController
                                      ?.initialData?.value?.thumbnail),
                          movieName: videoDetailsController
                                  ?.initialData?.value?.title ??
                              "Title",
                          movieType: videoDetailsController?.videoDetailsModel
                                  ?.value?.data?.video?.category?.name ??
                              "Category",
                          language: 'English',
                          resolution: videoDetailsController?.videoDetailsModel
                              ?.value?.data?.video?.videoResolution?.name,
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        /// read more button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ReadMoreText(
                            videoDetailsController?.videoDetailsModel?.value
                                    ?.data?.video?.description ??
                                '',
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

                        /// actions widget (report, like, dislike, favourite)
                        _getActionsWidget(videoDetailsController),
                        SizedBox(
                          height: 10,
                        ),

                        Divider(
                          thickness: .5,
                          color: AppColors.dividerColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        /// report input and submit button widget
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
                                            color: AppColors.searchBorderColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: reportText,
                                            cursorColor:
                                                AppColors.textFieldTextColor,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: AppColors
                                                    .textFieldTextColor,
                                                fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.only(
                                                  left: 20, top: 0, bottom: 8),
                                              hintText: 'Report details here',
                                              hintStyle: TextStyle(
                                                  fontSize: 9,
                                                  color: AppColors
                                                      .textFieldTextColor,
                                                  fontWeight: FontWeight.w300),
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
                                          await controller.getAddReportsMethod(
                                              id: videoDetailsController
                                                  .videoDetailsModel
                                                  .value
                                                  .data
                                                  .video
                                                  .id
                                                  .toString(),
                                              description: reportText.text);
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    BottomSheetSeason.bottomSheetPro(
                                      context: context,
                                      seasons: videoDetailsController
                                          .tvSeriesSeasonsModel.data.seasons,
                                    );
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Season:   ',
                                            style: TextStyle(
                                              fontFamily: 'poppins_bold',
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1
                                                  .color,
                                            ),
                                          ),
                                          Obx(() {
                                            return Text(
                                              videoDetailsController
                                                  .seasonNumber.value,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.shadowRed,
                                              ),
                                            );
                                          }),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColors.shadowRed,
                                          ),
                                        ],
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Episodes',
                              style: TextStyle(
                                fontFamily: 'poppins_bold',
                                fontSize: 13,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, top: 10, bottom: 5),
                              child: GestureDetector(
                                onTap: () {
                                  youtubePlayerCustomController
                                      ?.youPlayerController
                                      ?.pause();
                                  AppRouter.navToVideoDetailsMoreVideosPage(
                                      catName: "Similer videos",
                                      catImage: AppUrls.imageBaseUrl +
                                              videoDetailsController
                                                  ?.episodesList
                                                  ?.first
                                                  ?.thumbnail ??
                                          "https://picsum.photos/200",
                                      homeDataList:
                                          videoDetailsController?.episodesList,
                                      nestedId: widget.nestedId);
                                },
                                child: Text(
                                  'More',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: Color(0xffE15050)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : getOnlyVideoActionsShimmer(wp, hp),

              /// similar videos widget
              Container(
                height: wp(50) * (2 / 3),
                child: Obx(() {
                  if (videoDetailsController.episodesList.isEmpty) {
                    return Center(
                      child: Text(
                        'No episodes found',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1.color),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          videoDetailsController.episodesList.length ?? 0,
                      itemBuilder: (BuildContext context, int index) =>
                          SimilarImgCard(
                        episodeNumber: videoDetailsController
                            ?.episodesList[index].tvSeriesEpisodeNo,
                        onTap: () {
                          AdsMiddleWare.clickCountIncrement();
                          _similarOnTap(videoDetailsController, index);
                        },
                        imgPath: videoDetailsController
                                    ?.episodesList[index]?.thumbnail !=
                                null
                            ? AppUrls.imageBaseUrl +
                                videoDetailsController
                                    ?.episodesList[index]?.thumbnail
                            : "https://picsum.photos/200",
                      ),
                    );
                  }
                }),
              ),
              Divider(
                height: 8,
                thickness: .5,
                color: AppColors.dividerColor,
              ),
              SizedBox(
                height: 10,
              ),

              /// cast list of this movie widget
              (videoDetailsController.loadingDetails.value == false &&
                      videoDetailsController.videoDetailsModel.value != null)
                  ? CastCard(
                      actors: videoDetailsController
                          ?.videoDetailsModel?.value?.data?.video?.actors,
                      ontap: () {
                        youtubePlayerCustomController?.youPlayerController
                            ?.pause();
                        AppRouter.navToActorPage();
                      },
                    )
                  : getOnlyVideoActionsShimmer(wp, hp),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

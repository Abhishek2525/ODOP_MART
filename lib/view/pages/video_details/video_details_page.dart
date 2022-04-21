import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:iotflixcinema/core/services/premium_video_services.dart';
import 'package:share/share.dart';

import '../../../core/ads/banner/app_banner_ads.dart';
import '../../../core/api/app_urls.dart';
import '../../../core/controllers/similar_to_this_video_list_traker.dart';
import '../../../core/middle_ware/route_objerver.dart';
import '../../../core/models/home_categories_model.dart';
import '../../../core/utils/local_auth/local_auth_get_storage.dart';
import '../../../core/utils/toast/flutter_toast.dart';
import '../../../core/view_models/VideoDetailsViewModel.dart';
import '../../../core/view_models/ads/ads_view_model.dart';
import '../../../core/view_models/categories_view_model.dart';
import '../../../core/view_models/download_view_model/download_view_model.dart';
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
import 'similar_img_card.dart';
import 'vedio_player/vedio_player_view.dart';
import 'vedio_player/youtube_player.dart';
import 'video_details_info_card.dart';

/// documentation comment

class VideoDetailsPage extends StatefulWidget {
  final int nestedId;
  final int catId;
  final int videoId;

  VideoDetailsPage({this.nestedId, this.catId, this.videoId});

  @override
  _VideoDetailsPageState createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  Function wp;
  Function hp;

  double _animatedHeight = 0;
  bool makeReport = false;
  TextEditingController reportTextController = TextEditingController();
  FocusNode reportNode = FocusNode();

  var youtubePlayerCustomController = Get.put(YoutubePlayerCustomCntroller());

  var videoVIewController = Get.put(VideoViewViewModel());

  FavoriteViewModel favViewModel = Get.put(FavoriteViewModel());

  @override
  void dispose() {
    super.dispose();

    reportTextController.dispose();
  }

  CategoriesViewModel catModel = Get.put(CategoriesViewModel());

  @override
  void initState() {
    super.initState();

    /// call the video view count api
    videoVIewController.historyAddMethod(widget.videoId?.toString());

    try {
      favViewModel.setFavorite(widget.videoId);
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;
    return WillPopScope(
      onWillPop: () async {
        /// is user press the back button from video details page
        /// then clear similar videos tracker
        SimilarToThisVideoListTraker.playedSimilarVideos.clear();
        Get.back();
        return true;
      },
      child: Scaffold(
        body: GetBuilder<VideoDetailsViewModel>(
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

                    GetBuilder<AdsViewModel>(
                      builder: (c) => Container(
                        //   color: Colors.red,
                        //    height: 50,
                        child: AppBannerAds(
                          adsName: c.config?.type,
                        ),
                      ),
                    ),

                    _videoDetailsWidget(videoDetailsController),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// returns a widget that contains the video player and the appbar
  Widget _videoPlayerAndAppBar(VideoDetailsViewModel videoDetailsController) {
    return Stack(
      children: [
        VideoPlayerView(
          nestedId: widget?.nestedId,
          model: videoDetailsController?.initialData?.value,
          //videoUrl: videoDetailsController?.initialData?.value?.videoUrl,
          thumbnailUrl:
              (videoDetailsController?.initialData?.value?.thumbnail == null
                  ? 'https://picsum.photos/90'
                  : AppUrls.imageBaseUrl +
                      videoDetailsController?.initialData?.value?.thumbnail),
        ),
        InkResponse(
          splashColor: AppColors.white,
          onTap: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);

            /// is user press the app bars back button from video details page
            /// then clear similar videos tracker
            SimilarToThisVideoListTraker.playedSimilarVideos.clear();

            Get.back();
          },
          child: Container(
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
  ///
  Widget _getActionsWidget(VideoDetailsViewModel videoDetailsController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: LocalDBUtils.getJWTToken() == null
                  ? _handleUnAuthenticateduser
                  : () {
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
                            c.deleteFavoriteData(
                              videoDetailsController?.initialData?.value?.id
                                  ?.toString(),
                            );
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
                          fontWeight: FontWeight.w500,
                        ),
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

                  /// handle like
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
                      videoDetailsController?.initialData?.value?.like?.toString() ??
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
          /// dislike widget
          Expanded(
            flex: 1,
            child: InkResponse(
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
                      /// handle unlike
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
                    videoDetailsController?.initialData?.value?.dislike?.toString() ??
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
            ),
          ),
          /// download widget
          if (LocalDBUtils.getJWTToken() != null)
            if (videoDetailsController?.initialData?.value?.videoUrl == null ||
                videoDetailsController.initialData.value.videoUrl
                    .contains("youtube.com"))
              Container()
            else
              Expanded(
                flex: 1,
                child: GetBuilder<DownloadViewModel>(
                  builder: (c) => GestureDetector(
                    onTap: () async {
                      if (c.isDownloaded(
                              videoDetailsController?.initialData?.value?.id ??
                                  -1) ==
                          false) {
                        c.addToDownload(
                            videoDetailsController?.initialData?.value);
                      }
                    },
                    child: Column(
                      children: [
                        ImageIcon(
                          AssetImage('images/download-circular-button.png'),
                          color: c.isDownloaded(videoDetailsController
                                      ?.initialData?.value?.id ??
                                  -1)
                              ? AppColors.red
                              : AppColors.borderColor,
                          size: 22,
                        ),
                        Text(
                          "downloaded",
                          style: TextStyle(
                              color: c.isDownloaded(videoDetailsController
                                          ?.initialData?.value?.id ??
                                      -1)
                                  ? AppColors.red
                                  : AppColors.borderColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
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
      message: 'You are not logged in.\nPlease login to continue.',
    );
  }

  /// this method is called when tapping any item from similar videos
  void _similarOntap(var videoDetailsController, HomeData videoModel) async {

    if(videoModel.isPremium == 1){
      if (PremiumVideoServices.userIsAPremiumUser() == false){
        return;
      }
    }

    videoDetailsController.refreshData(videoModel);

    videoVIewController.model.value = null;
    videoVIewController.model.value = videoModel;

    String strUrl = videoModel?.videoUrl;
    String videoId = videoModel?.id?.toString();
    String videoName = videoModel?.title;

    /// call is favorite method to check the video is in fav list or not
    favViewModel.setFavorite(int.parse(videoId));

    if (!strUrl.contains('youtube') && !strUrl.contains('vimeo')) {
      AppPlayerController appPlayerController = Get.put(AppPlayerController());

      /// save last played video info
      await appPlayerController?.saveLastPlayedVideoInfo();

      /// play new video
      appPlayerController?.initBetterPlayerController(
          strUrl, videoId, videoName);
    } else {
      /// save last played video info
      await youtubePlayerCustomController?.saveLastPlayedVideoInfo();

      /// update youtube player video source with new video
      youtubePlayerCustomController.playMethod(strUrl, videoId, videoName);

      ///call video view count api
      videoVIewController.historyAddMethod(videoModel?.id.toString());
    }
  }

  Widget _videoDetailsWidget(VideoDetailsViewModel videoDetailsController) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),

        /// The video details widget
        /// Similar video widget
        /// Actors Widget
        (videoDetailsController.loadingDetails.value == false &&
                videoDetailsController.videoDetailsModel.value != null)
            ? Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Column(
                  children: [
                    SizedBox(height: 10),

                    /// video details widget
                    VideoDetailsInfoCard(
                      imgPath: (videoDetailsController
                                  ?.initialData?.value?.thumbnail ==
                              null
                          ? 'https://picsum.photos/90'
                          : AppUrls.imageBaseUrl +
                              videoDetailsController
                                  ?.initialData?.value?.thumbnail),
                      movieName:
                          videoDetailsController?.initialData?.value?.title ??
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
                        videoDetailsController?.initialData?.value?.description ??
                            '',
                        textStyle: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
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
                                margin:
                                    EdgeInsets.only(left: 15.0, right: 15.0),
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                        color: AppColors.searchBorderColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        focusNode: reportNode,
                                        controller: reportTextController,
                                        cursorColor:
                                            AppColors.textFieldTextColor,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: AppColors.textFieldTextColor,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.only(
                                              left: 20, top: 0, bottom: 8),
                                          hintText: 'Report details here',
                                          hintStyle: TextStyle(
                                              fontSize: 9,
                                              color:
                                                  AppColors.textFieldTextColor,
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
                                    reportNode.unfocus();
                                    if (reportTextController.text != null &&
                                        reportTextController.text != '') {
                                      await controller.getAddReportsMethod(
                                          id: videoDetailsController
                                              .videoDetailsModel
                                              .value
                                              .data
                                              .video
                                              .id
                                              .toString(),
                                          description:
                                              reportTextController.text);
                                      if (controller.addReportsModel.status ==
                                          true) {
                                        FlutterToast.showSuccess(
                                            message: "Reported Successfully",
                                            context: context);
                                      }
                                    }

                                    setState(() {
                                      reportTextController.clear();
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

                    /// similar videos widget
                    _similarToThisWidget(videoDetailsController),
                    Divider(
                      height: 8,
                      thickness: .5,
                      color: AppColors.dividerColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /// cast list of this movie widget
                    CastCard(
                      actors: videoDetailsController
                          ?.videoDetailsModel?.value?.data?.video?.actors,
                      ontap: () {
                        youtubePlayerCustomController?.youPlayerController
                            ?.pause();
                      },
                    )
                  ],
                ),
              )
            : getVideoDetailsShimmer(wp, hp),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  /// this method return the similar video list widget
  Widget _similarToThisWidget(VideoDetailsViewModel videoDetailsController) {
    List<HomeData> seeMoreList = [];
    seeMoreList
        .addAll(videoDetailsController?.categoryMaylikeModel?.data ?? []);
    List<HomeData> similarVideoList =
        videoDetailsController?.categoryMaylikeModel?.data ?? [];

    /// remove the currently playing video from similar to this video list
    /// if exist
    int currentVideoId = videoDetailsController?.initialData?.value?.id;
    if (currentVideoId != null) {
      for (int i = 0; i < similarVideoList.length; i++) {
        int tempId = similarVideoList[i].id;
        if (currentVideoId == tempId) {
          similarVideoList.removeAt(i);
          break;
        }
      }
    }

    /// remove video from similar videos list
    /// if the video already played from similar list
    for (int playedVideoId
        in SimilarToThisVideoListTraker.playedSimilarVideos) {
      for (int i = 0; i < similarVideoList.length; i++) {
        int vid = similarVideoList[i].id;
        if (playedVideoId == vid) {
          similarVideoList.removeAt(i);
        }
      }
    }

    if (similarVideoList.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Similar To This',
              style: TextStyle(
                fontFamily: 'poppins_bold',
                fontSize: 14,
                color: Theme.of(context).textTheme.headline1.color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 5),
              child: InkWell(
                onTap: () {
                  /// pause video before going to more videos page
                  try {
                    YoutubePlayerCustomCntroller youCustomCntrllr =
                        Get.put(YoutubePlayerCustomCntroller());
                    youCustomCntrllr?.youPlayerController?.pause();
                    AppPlayerController appCntrllr =
                        Get.put(AppPlayerController());
                    appCntrllr?.betterPlayerController?.pause();
                  } catch (error) {}

                  AppRouter.navToVideoDetailsMoreVideosPage(
                      catName: "Similer videos",
                      catImage: AppUrls.imageBaseUrl +
                              videoDetailsController?.categoryMaylikeModel?.data
                                  ?.first?.thumbnail ??
                          "https://picsum.photos/200",
                      homeDataList: seeMoreList,
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
        Container(
          height: wp(50) * (2 / 3),
          child: ListView.builder(
            // physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: similarVideoList.length,
            itemBuilder: (BuildContext context, int index) => SimilarImgCard(
              onTap: () {
                AdsMiddleWare.clickCountIncrement();
                _similarOntap(videoDetailsController, similarVideoList[index]);
              },
              imgPath: similarVideoList[index]?.thumbnail != null
                  ? AppUrls.imageBaseUrl + similarVideoList[index]?.thumbnail
                  : "https://picsum.photos/200",
            ),
          ),
        ),
      ],
    );
  }
}

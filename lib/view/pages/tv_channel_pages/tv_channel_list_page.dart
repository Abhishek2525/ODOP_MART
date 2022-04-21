import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:iotflixcinema/core/services/premium_video_services.dart';
import 'package:shape_of_view/shape_of_view.dart';

import '../../../core/api/app_urls.dart';
import '../../../core/models/tv_channel.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../../core/view_models/tv_channel_view_models/tv_channel_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/shimmers/grid_shimmer.dart';
import 'watch_tv_page.dart';

class TvChannelListPage extends StatefulWidget {
  const TvChannelListPage({Key key}) : super(key: key);

  @override
  _TvChannelListPageState createState() => _TvChannelListPageState();
}

class _TvChannelListPageState extends State<TvChannelListPage> {
  Function wp;
  Function hp;

  TvChannelViewModel _viewModel = Get.put(TvChannelViewModel());

  @override
  Widget build(BuildContext context) {
    wp = Screen(MediaQuery.of(context).size).wp;
    hp = Screen(MediaQuery.of(context).size).hp;

    return SafeArea(
      child: Scaffold(
        appBar: IotaAppBar.appBarWithTitle(
          title: "Live Channels",
          backButtonOnTap: () {
            AppRouter.back();
          },
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Obx(() {
              if (_viewModel.tvChannelListLoading.value) {
                return Center(
                  child: getGridShimmer(wp, hp),
                );
              } else {
                return _getChannelListWidget();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _getChannelListWidget() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _viewModel.tvChannelList.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 250.0 / 250.0,
      ),
      itemBuilder: (context, index) {
        TvChannel channel = _viewModel.tvChannelList[index];

        return GestureDetector(
          onTap: () {
            if(channel.isPremium == 1){
              bool userIsPremium = PremiumVideoServices.userIsAPremiumUser();
              if(userIsPremium){
                Get.to(() => WatchTvPage(channel));
              }
            }else{
              Get.to(() => WatchTvPage(channel));
            }
          },
          child: Container(
            child: ShapeOfView(
              shape: RoundRectShape(
                borderRadius: BorderRadius.circular(10),
                borderColor: AppColors.appAmber,
                borderWidth: 2,
              ),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                    // color: Colors.black,
                    image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    AppUrls.imageBaseUrl + channel.img,
                    cache: true,
                    cacheRawData: true,
                    imageCacheName: AppUrls.imageBaseUrl + channel.img,
                  ),
                  fit: BoxFit.cover,
                )),
                child: GetBuilder<ThemeController>(
                  builder: (controller) => Container(
                    color: controller.themeMode.index == 2
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.4),
                    child: Center(
                      child: Text(
                        channel.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

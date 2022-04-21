import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_responsive_screen/flutter_responsive_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/constant/app_constant.dart';
import '../../../core/repo/vedio_view/history_add_repo.dart';
import '../../../core/view_models/history_view_model/history_view_model.dart';
import '../../../core/view_models/theme_view_model.dart';
import '../../cards/app_bars/app_bar_with_title.dart';
import '../../constant/app_colors.dart';
import '../../router/app_router.dart';
import '../../widgets/shimmers/list_shimmer.dart';
import 'card/history_card.dart';

class HistoryPage extends StatefulWidget {
  final int nestedId;

  HistoryPage({this.nestedId});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int rebuild = 0;
  int page = 1;

  ScrollController controller = ScrollController();

  HistoryViewModel viewModel = Get.find();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print("max scroll position ");
        viewModel.getHistoryData(page: ++page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Function wp = Screen(MediaQuery.of(context).size).wp;
    Function hp = Screen(MediaQuery.of(context).size).hp;
    return Scaffold(
      appBar: IotaAppBar.historyPageAppbar(
        title: "History",
        borderColor: AppColors.deepRed,
        backButtonOnTap: () {
          AppRouter.back();
        },
        actionOnTap: _actionOnTap,
      ),
      body: SafeArea(
        child: GetX<HistoryViewModel>(
          builder: (c) {
            if (c.historyLoading.value == true && c.firstTime.value == true) {
              return getListShimmer(wp, hp, itemCount: 10);
            }
            if (c.historyLoading.value == false &&
                c.historyDataModel.value.data.data.isEmpty) {
              bool isDarkTheme = ThemeController.currentThemeIsDark;
              String noDataImagePath = ImageNames.noDataForDarkTheme;
              if (isDarkTheme == false) {
                noDataImagePath = ImageNames.noDataForLightTheme;
              }

              return Center(
                child: Container(
                  height: wp(30),
                  width: wp(30),
                  child: Image.asset(noDataImagePath),
                ),
              );
            } else {
              c.firstTime.value = false;
              return SmartRefresher(
                controller: _refreshController,
                enablePullDown: false,
                enablePullUp: true,
                footer: CustomFooter(
                  builder: (context, loadStatus) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
                ),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount:
                      (c.historyDataModel?.value?.data?.data?.length ?? 0),
                  itemBuilder: (BuildContext context, int index) {
                    return HistoryItemCard(
                      model: c.historyDataModel?.value?.data?.data[index],
                      imgPath: c.historyDataModel?.value?.data?.data[index]
                          ?.video?.thumbnail,
                      onTap: () {
                        AppRouter.navToVideoDetailsPage(
                            c.historyDataModel?.value?.data?.data[index]?.video,
                            widget?.nestedId,
                            c.historyDataModel?.value?.data?.data[index]?.video
                                ?.categoryId);
                      },
                      onDelete: () {
                        setState(() {
                          c.historyDataModel?.value?.data?.data
                              ?.removeAt(index);
                        });
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _actionOnTap() {
    Get.defaultDialog(
      title: 'Attention!',
      titleStyle: TextStyle(color: Theme.of(context).textTheme.headline2.color),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Are you sure to clear all history data?',
          style: TextStyle(color: Theme.of(context).textTheme.headline2.color),
        ),
      ),
      barrierDismissible: true,
      radius: 5,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                primary: AppColors.green,
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                HistoryAddRepo hRepo = HistoryAddRepo();
                hRepo.deleteAllHistory();
              },
              style: TextButton.styleFrom(
                primary: AppColors.deepRed,
              ),
              child: Text('Confirm'),
            ),
          ],
        ),
      ],
    );
  }
}

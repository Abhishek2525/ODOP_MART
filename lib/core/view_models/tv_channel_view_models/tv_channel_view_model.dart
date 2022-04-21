import 'package:get/get.dart';

import '../../../view/pages/tv_channel_pages/watch_tv_page.dart';
import '../../models/tv_channel.dart';
import '../../repo/tv_channel_repo/tv_channel_repo.dart';

/// A [Get] controller for managing state of [WatchTvPage] widget
class TvChannelViewModel extends GetxController {
  RxList<TvChannel> tvChannelList = <TvChannel>[].obs;

  /// Indicate whether TV channel list is loading or loaded from server
  Rx<bool> tvChannelListLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTvChannelList();
  }

  /// Get all TV Channel List using [TvChannelRepo]
  void getTvChannelList() async {
    tvChannelListLoading.value = true;
    tvChannelList.value = await TvChannelRepo().getTvChannelList();
    tvChannelListLoading.value = false;
  }
}

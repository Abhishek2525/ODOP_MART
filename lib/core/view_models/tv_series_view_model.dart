import 'package:get/get.dart';

import '../../view/pages/tv_series_category/tv_series_category_page.dart';
import '../../view/pages/tv_series_category/tv_series_seasons_page.dart';
import '../models/tv_series_model.dart';
import '../models/tv_series_season_episode_model.dart';
import '../models/tv_series_seasons_model.dart';

/// This is a [GetX] controller
///
/// Allow to manage app state specifically for [TvSeriesCategoryPage]
///
/// This controller responsible for manging TvSeries related data management
/// for [TvSeriesCategoryPage], [TvSeriesSeasonsPage],
///
/// Here we are using [Get] as State Management Library
/// Allow to update User Interface in runtime of application and separating
/// the logical portion of application from View
class TvSeriesViewModel extends GetxController {
  Rx<TvSeriesSeasonsModel> tvSeriesSeasonsModel = TvSeriesSeasonsModel().obs;
  Rx<bool> tvSeriesSeasonEpisodeLoading = false.obs;

  Rx<TvSeriesModel> tvSeriesModel = TvSeriesModel().obs;
  Rx<bool> tvSeriesLoading = false.obs;

  Rx<Episodes> initialData = Episodes().obs;
  Rx<bool> initialDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    /// Call this method to get all TV series from server
    callTvSeriesMethod();
  }

  /// This method call a method of [TvSeriesModel] class and get all TV-series list
  /// from server
  callTvSeriesMethod() async {
    tvSeriesLoading.value = true;
    await tvSeriesModel.value.callApi();
    tvSeriesLoading.value = false;
  }

  /// This method call a method of [TvSeriesSeasonsModel] data class and get all
  /// TV series seaons from server
  getTvSeriesSeasonsMethod({String id}) async {
    tvSeriesSeasonEpisodeLoading.value = true;
    TvSeriesSeasonsModel temp = TvSeriesSeasonsModel();
    await temp?.callApi(id: id);
    tvSeriesSeasonsModel.value = temp;
    tvSeriesSeasonEpisodeLoading.value = false;
  }

  /// This method call a method of [TVSeriesSeasonEpisodeModel] data class and
  /// get all TV Series Seasons Episodes from server
  getTvSeriesSeasonEpisodeMethode({
    String type,
    int seasonid,
    int episode,
  }) async {
    TVSeriesSeasonEpisodeModel tempModel = TVSeriesSeasonEpisodeModel();
    await tempModel.callApi(
      episode: episode,
      seasonid: seasonid,
      type: type,
    );
    tvSeriesSeasonEpisodeModel.value = tempModel;
  }

  Rx<TVSeriesSeasonEpisodeModel> tvSeriesSeasonEpisodeModel =
      TVSeriesSeasonEpisodeModel().obs;

  /// This method sets initial data
  setInitialData(Episodes newVideo) {
    initialDataLoading.value = true;
    Future.delayed(Duration(milliseconds: 200));
    initialData.value = newVideo;
    initialDataLoading.value = false;
  }
}

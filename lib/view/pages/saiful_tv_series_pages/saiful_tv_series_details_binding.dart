import 'package:get/get.dart';

import '../../../core/models/home_categories_model.dart';
import '../../../core/view_models/categories_view_model.dart';
import '../../../core/view_models/fevorite_view_model.dart';
import '../../../core/view_models/reports_view_model.dart';
import '../../../core/view_models/video_view_view_model.dart';
import 'saiful_tv_series_details_view_model.dart';

class SaifulTvSeriesDetailsBinding extends Bindings {
  SaifulTvSeriesDetailsBinding(this.initialData, this.episodeList);

  @override
  void dependencies() {
    print("dependencies \n ${initialData?.title}");
    Get.put(SaifulTvSeriesDetailsViewModel(this.initialData, this.episodeList));
    Get.put(ReportsViewModel());
    Get.put(FavoriteViewModel());
    Get.put(CategoriesViewModel());
    Get.lazyPut(() => VideoViewViewModel());
  }

  final HomeData initialData;
  final List<HomeData> episodeList;
}

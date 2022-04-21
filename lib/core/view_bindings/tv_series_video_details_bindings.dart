import 'package:get/get.dart';

import '../models/home_categories_model.dart';
import '../view_models/VideoDetailsViewModel.dart';
import '../view_models/categories_view_model.dart';
import '../view_models/fevorite_view_model.dart';
import '../view_models/reports_view_model.dart';
import '../view_models/tv_series_view_model.dart';
import '../view_models/video_view_view_model.dart';

class TvSeriesVideoDetailsBindings extends Bindings {
  TvSeriesVideoDetailsBindings(this.initialData);

  @override
  void dependencies() {
    Get.put(ReportsViewModel());
    Get.put(TvSeriesViewModel());
    Get.lazyPut(() => VideoViewViewModel());
    Get.put(VideoDetailsViewModel(this.initialData));

    Get.put(FavoriteViewModel());
    Get.put(CategoriesViewModel());
  }

  final HomeData initialData;
}

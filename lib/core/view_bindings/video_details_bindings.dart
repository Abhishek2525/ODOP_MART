import 'package:get/get.dart';

import '../models/home_categories_model.dart';
import '../view_models/VideoDetailsViewModel.dart';
import '../view_models/categories_view_model.dart';
import '../view_models/fevorite_view_model.dart';
import '../view_models/reports_view_model.dart';
import '../view_models/video_view_view_model.dart';

class VideoDetailsBindings extends Bindings {
  VideoDetailsBindings(this.initialData);

  @override
  void dependencies() {
    Get.put(VideoDetailsViewModel(this.initialData));
    Get.put(ReportsViewModel());
    Get.put(FavoriteViewModel());
    Get.put(CategoriesViewModel());
    Get.lazyPut(() => VideoViewViewModel());
  }

  final HomeData initialData;
}

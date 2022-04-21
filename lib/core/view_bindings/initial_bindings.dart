import 'package:get/get.dart';
import 'package:iotflixcinema/core/view_models/subscription_payment_viewmodel.dart';

import '../view_models/all_videos_view_model.dart';
import '../view_models/categories_view_model.dart';
import '../view_models/download_view_model/download_view_model.dart';
import '../view_models/fevorite_view_model.dart';
import '../view_models/filter_videos_view_model.dart';
import '../view_models/home_banner_view_model.dart';
import '../view_models/home_categories_view_model.dart';
import '../view_models/keep_watching_controller.dart';
import '../view_models/profile_view_model.dart';
import '../view_models/settings_view_model.dart';
import '../view_models/sponsor_view_model.dart';
import '../view_models/tv_series_view_model.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingsViewModel());

    Get.put(HomeBannerViewModel());
    Get.put(SponsorViewModel());
    Get.put(AllVideosViewModel());
    Get.put(CategoriesViewModel());
    Get.put(HomeCategoriesViewModel());
    Get.put(TvSeriesViewModel());
    Get.put(ProfileViewModel());
    Get.put(BottomSheetController());
    Get.put(KeepWatchingController());

    Get.put(FavoriteViewModel());
    Get.put(DownloadViewModel());
    Get.put(SubscriptionPaymentViewModel());
  }
}

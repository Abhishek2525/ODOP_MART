import 'package:get/get.dart';

import '../view_models/fevorite_view_model.dart';
import '../view_models/home_view_model.dart';
import '../view_models/search/search_view_model.dart';

class HomePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeViewModel());
    Get.put(FavoriteViewModel());
    Get.lazyPut(() => SearchViewModel());
  }
}

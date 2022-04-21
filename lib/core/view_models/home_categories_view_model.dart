import 'package:get/get.dart';

import '../../view/pages/dashboard/dashboard_screen.dart';
import '../models/home_categories_model.dart';

/// A [GetxController] used in [Dashboard] Widget
class HomeCategoriesViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getHomeCategoriesMethod();
  }

  /// This field contains all category wise video list those are used in homepage
  HomeCategoriesModel homeCategoriesModel = HomeCategoriesModel();

  /// This method call an Api and retrieve HomeCategories from network
  getHomeCategoriesMethod() async {
    HomeCategoriesModel temp = HomeCategoriesModel();

    await temp.callApi();
    homeCategoriesModel = temp;
    update();
  }
}

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/CategoriesModel.dart';
import '../models/sub_categories_all_videos.dart';
import '../models/sub_categories_model.dart';

/// This is a [GetX] controller
///
/// Allow to manage app state specifically for managing video category
/// related work.
///
/// Here we are using [Get] as State Management Library
/// Allow to update User Interface in runtime of application and separating
/// the logical portion of application from View
class CategoriesViewModel extends GetxController {
  /// Contains all video [SubCategories]
  Rx<SubCategoriesModel> subCategoriesModel = SubCategoriesModel().obs;

  /// keep trace of whether subCategory list retrieving from server or retrieved
  Rx<bool> subCategoryLoading = false.obs;

  /// Contains all categories [List]
  CategoriesModel categoriesModel = CategoriesModel();

  /// Contains all videos of a [SubCategory]
  Rx<SubCategoryAllVideosModel> subCategoryAllVideosModel =
      SubCategoryAllVideosModel().obs;

  /// Keep trace whether video [List] retrieved from server or not
  Rx<bool> videoLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  /// This method get all video categories from server
  getCategories() async {
    CategoriesModel tempModel = CategoriesModel();
    await tempModel.callApi();
    categoriesModel = tempModel;
  }

  /// This method get video subcategory list from server
  /// using [SubCategoriesModel]
  getSubCategories({int id}) async {
    subCategoryLoading.value = true;
    subCategoriesModel.value?.data?.categoryVideo?.data1?.clear();
    SubCategoriesModel tempModel = SubCategoriesModel();
    await tempModel.callApi(id: id);
    subCategoriesModel.value = tempModel;
    subCategoryLoading.value = false;
  }

  /// This method get all videos by subcategory id from the server
  getSubCategoriesAllVideos({int id}) async {
    videoLoading.value = true;
    subCategoryAllVideosModel.value?.data?.data1?.clear();
    SubCategoryAllVideosModel tempModel = SubCategoryAllVideosModel();
    await tempModel.callApi(id: id);
    subCategoryAllVideosModel.value = tempModel;
    videoLoading.value = false;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../view/pages/all_video_page/filter_bottom_sheet/filter_bottom_sheet.dart';
import '../api/app_urls.dart';
import '../models/filter_videos_model.dart';
import 'all_videos_view_model.dart';

import 'package:iotflixcinema/core/models/all_videos_model.dart'
    as allVideoModelClass;

class BottomSheetController extends GetxController {
  /// Video category related fields
  RxList<String> selectedCategory = <String>[].obs;
  List<int> selectedCategoryIdList = [];
  RxList<String> categoryList = <String>[].obs;
  List<int> categoryIdList = <int>[];

  ///Video sub-category related fields
  RxList<Map<String, String>> subCategoryMapList = <Map<String, String>>[].obs;
  RxList<String> selectedSubcategoryIdList = <String>[].obs;

  /// Video resolution related fields
  RxList<int> selectedQualityList = <int>[].obs;
  List<int> selectedQualityIdList = [];
  RxList<int> qualityList = <int>[].obs;
  List<int> qualityIdList = [];

  /// this field represent The time videos was uploaded
  Rx<String> selectedUploadTime = ''.obs;

  /// This field represent Total likes to be filter
  Rx<String> selectedTotalLike = '0'.obs;

  /// seekbar related field
  Rx<double> currentSeekBarValue = 100.0.obs;
  double minSeekBarValue = 0;
  double maxSeekbarValue = 10000;

  RxList<String> timeList = <String>['all-time', 'week', 'month', 'year'].obs;

  /// This field holds the all videos fetched from the network
  AllVideosViewModel allVideosViewModel = Get.put(AllVideosViewModel());

  @override
  void onInit() {
    super.onInit();

    getCategoryList();
    getResulutionList();
  }

  /// This method triggers when user press the reset [Button]
  /// from [BottomSheetFilter] bottom sheet [Widget]
  /// and reset all filtered field to initial position
  ///
  void resetButtonOnTap() {
    selectedCategory.value = <String>[];
    selectedCategoryIdList = [];

    selectedSubcategoryIdList.clear();
    subCategoryMapList.refresh();

    selectedQualityList.value = <int>[];
    selectedQualityIdList = [];

    selectedUploadTime.value = '';
    selectedTotalLike.value = '0';
    currentSeekBarValue.value = 0.0;

    allVideosViewModel.getAllVideosMethod();
  }

  /// This method triggers when user press the [Apply] Button from [BottomSheetFilter]
  /// bottom sheet widget
  void applyButtonOnTap() {
    String time =
        selectedUploadTime.value == '' ? 'all-time' : selectedUploadTime.value;

    /// Calling the method for filtering
    getFilterVideosMethod(
      categoryIds: selectedCategoryIdList,
      resolutions: selectedQualityIdList,
      time: time,
      totalLike: currentSeekBarValue.toInt(),
      subCategoryIds: selectedSubcategoryIdList,
    );
  }

  FilterVideosModel filterVideosModel = FilterVideosModel();

  /// This method perform filter operation
  ///
  /// after a successful filter the filtered
  /// data saved into [filterVideosModel] field
  getFilterVideosMethod({
    int totalLike,
    String time,
    List<int> resolutions,
    List<int> categoryIds,
    List<String> subCategoryIds,
  }) async {
    allVideosViewModel.allVideoLoading.value = true;

    FilterVideosModel tempModel = FilterVideosModel();

    /// performing the filter operation
    await tempModel.callApi(
      resolutions: resolutions,
      time: time,
      totalLike: totalLike,
      categoryIds: categoryIds,
      subCategoryIds: subCategoryIds,
    );
    filterVideosModel = tempModel;

    allVideosViewModel.allVideoLoading.value = false;

    /// update all video VideModel With the new filtered videos
    allVideosViewModel.allVideosModel?.value?.data?.clear();
    //int i = 0;
    for (Data1 hData in filterVideosModel?.data?.data1) {
      allVideoModelClass.Data data =
          allVideoModelClass.Data.fromJson(hData.toJson());
      allVideosViewModel.allVideosModel?.value?.data?.add(data);
    }
    allVideosViewModel.allVideosModel.refresh();
  }

  /// This method makes an API call
  /// and retrieve video category list from network
  Future<void> getCategoryList() async {
    try {
      String url = AppUrls.getOnlyCategoryListUrl;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var map = jsonDecode(response.body);
        for (var jMap in map['data']) {
          categoryList.add(jMap['name']);
          categoryIdList.add(jMap['id']);
        }
      } else {}
    } catch (error) {
      print('get category list catches error = $error');
    }
  }

  /// This method makes an API call
  /// and retrieve video resolution list from network
  Future<void> getResulutionList() async {
    try {
      String url = AppUrls.getResulutionListUrl;

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        for (var map in data) {
          qualityList.add(map['name']);
          qualityIdList.add(map['id']);
        }
      }
    } catch (error) {
      print('cached error = $error');
    }
  }

  /// This method makes an API call
  /// and retrieve video subcategory list frem network
  Future<void> getSubCategoryList() async {
    /// clear the subcategory list
    subCategoryMapList.clear();
    selectedSubcategoryIdList.clear();

    String categoryId = '';

    if (selectedCategoryIdList.length > 1 ||
        selectedCategoryIdList.length < 1) {
      /// return the method without calling the api because there are multiple
      /// value in category list or there are no category selected
      return;
    }

    /// if the only one category selected then set the category id and call the api
    categoryId = selectedCategoryIdList?.first?.toString();

    String url = AppUrls.getSubcategoryListBuCategoryIdUrl(categoryId);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        for (var json in jsonDecode(response.body)['data']['subcategory']) {
          subCategoryMapList.add({
            'name': json['name'],
            'id': json['id'].toString(),
          });
        }
      } else {
        print('BottomSheetController.getSubCategoryList ** ' +
            'code = ${response.statusCode}');
      }
    } catch (err) {
      print('BottomSheetController.getSubCategoryList ** ' +
          'cached error = $err');
    }
  }
}

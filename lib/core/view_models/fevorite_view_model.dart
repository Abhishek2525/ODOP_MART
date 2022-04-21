import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../view/pages/favorite_page/Favorite_Page.dart';
import '../models/all_favorite_data_model.dart';
import '../repo/wish_list/wish_list_repo.dart';

/// A [GetxController] responsible for managing state and controlling
/// logical operations of [FavoritePage]
class FavoriteViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getFavoriteData();
  }

  /// This method get all favourite video list from server
  getFavoriteData() async {
    favoriteDataLoading.value = true;
    update();
    AllFavoriteDataModel temp = AllFavoriteDataModel();
    await temp.callApi();
    allFavoriteModel?.value = temp;
    favoriteDataLoading.value = false;
    firstTimeHere = false;
    update();
  }

  /// This method delete a single favorite item from server
  deleteFavoriteData(String id) async {
    isFavorite.value = !isFavorite.value;
    update();

    var status = await WishListRepo()?.deleteFavorite(id);
    getFavoriteData();
    return status;
  }

  /// this method add a favorite video item to favorite list in the server
  addFavoriteData(String id, BuildContext context) async {
    isFavorite.value = !isFavorite.value;
    update();

    var status = await WishListRepo()?.addFavorite(id);
    getFavoriteData();
    return status;
  }

  /// This method add a favorite item to favorite list in the server
  setFavorite(int id) async {
    isFavorite.value = false;
    isFavorite.value = await WishListRepo().isFavorite(id.toString());
    update();
  }

  /// This field hold the value of a video. is the video is favorite video of the user
  Rx<bool> isFavorite = false.obs;

  /// Indicates whether data loaded from network or loading
  Rx<bool> favoriteDataLoading = false.obs;

  /// This field works as fag variable
  bool firstTimeHere = true;

  /// This field hold favorite data
  Rx<AllFavoriteDataModel> allFavoriteModel = AllFavoriteDataModel().obs;
}

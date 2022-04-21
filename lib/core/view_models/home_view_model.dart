import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import '../../view/pages/favorite_page/Favorite_Page.dart';
import '../../view/pages/favorite_page/widget/FavoriteCards.dart';
import '../../view/pages/home/homepage.dart';
import '../constant/dev/movie_constant.dart';

/// This class is the controller of [HomePage]
///
/// Allow to manage [HomePage] state
///
/// Here we are using [Get] as State Management Library
/// Allow to update User Interface in runtime of application and separating
/// the logical portion of application from View
class HomeViewModel extends GetxController {
  @override
  void onInit() {
    renderFavoriteWidgets();
    super.onInit();
  }

  /// generate a list of widget with favourite video list images
  renderFavoriteWidgets() {
    for (int i = 0; i < MovieConstant.movieList.length; i++) {
      favoriteWidgets.add(FavoriteItemCard(
        imgPath: MovieConstant.getMovie(i),
      ));
    }

    listViewWidget.value = ListView(
      padding: EdgeInsets.symmetric(horizontal: 5),
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: favoriteWidgets,
    );
  }

  Rx<Widget> listViewWidget = Rx<Widget>(null);

  /// Represents a list of widget used in [FavoritePage]
  RxList<Widget> favoriteWidgets = RxList();
}

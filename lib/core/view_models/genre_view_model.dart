import 'package:get/get.dart';

import '../../view/pages/genre/genre_page.dart';
import '../models/genre_model.dart';

/// This is a [GetX] controller
///
/// Allow to manage state through out the application, specifically for [GenrePage]
///
/// Here we are using [Get] as State Management Library
/// Allow to update User Interface in runtime of application and separating
/// the logical portion of application from View
class GenreViewModel extends GetxController {
  /// This field keep trace whether [GenreModel] data
  /// loading from server
  bool genreLoading = false;

  /// This field contains [GenreModel]
  GenreModel genreModel = GenreModel();

  @override
  void onInit() {
    super.onInit();

    /// Call method to get data from server
    getGenreMethod();
  }

  /// This method call an Api and get all [GenreModel] as list and update
  /// [genreModel] field with new value
  getGenreMethod() async {
    try {
      genreLoading = true;
      update();
      GenreModel tempModel = GenreModel();
      await tempModel?.callApi();
      genreModel = tempModel;
      genreLoading = false;
      update();
    } catch (e) {}
  }
}

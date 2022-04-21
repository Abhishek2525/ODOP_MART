import 'package:get/get.dart';

import '../../view/pages/genre/genre_page.dart';
import '../models/genre_all_movies_model.dart';

/// A [GetxController] to manage state with related to [GenrePage] widget
/// And separating the logical portion of codes from UI
class GenreAllMoviesViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  /// This method call an API call
  ///
  /// And get all movies of a specific genre by genre ID
  getGenreAllMoviesMethod(String id) async {
    genreAllMoviesModelLoading = true;
    genreAllMoviesModel?.data?.data1 = [];
    update();
    try {
      await genreAllMoviesModel.callApi(id);
      genreAllMoviesModelLoading = false;
      update();
    } catch (e) {}
  }

  bool genreAllMoviesModelLoading = false;
  GenreAllMoviesModel genreAllMoviesModel = GenreAllMoviesModel();
}

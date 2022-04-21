import 'package:get/get.dart';

import '../../view/pages/country/country_all_movies_page.dart';
import '../models/country_All_videos_model.dart';

/// A [Get] Controller to manage State of [CountryAllMoviesPage] Widget
class CountryAllMoviesViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  /// indicate whether data loading from internet or not
  /// we show progress indicator based on this field
  bool loading = false;

  /// This method get all movies for a specific country
  /// by using country id
  getCountryAllMoviesMethod({String id}) async {
    try {
      loading = true;
      update();
      CountryAllMoviesModel tempModel = CountryAllMoviesModel();
      await tempModel.callApi(id: id);
      countryAllMoviesModel = tempModel;
      loading = false;
      update();
    } catch (e) {}
  }

  /// Retrieve and Contains all movies for a specific country from server
  CountryAllMoviesModel countryAllMoviesModel = CountryAllMoviesModel();
}

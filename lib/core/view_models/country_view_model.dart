import 'package:get/get.dart';

import '../models/country_model.dart';

/// This is a [GetX] controller
///
/// Allow to manage state through out the application
///
/// Here we are using [Get] as State Management Library
/// Allow to update User Interface in runtime of application and separating
/// the logical portion of application from View
class CountryViewModel extends GetxController {
  /// Contains all country [List]
  Rx<CountryModel> countryModelRx = CountryModel().obs;

  /// A single country model
  CountryModel countryModel = CountryModel();

  @override
  void onInit() {
    super.onInit();
    getCountryMethod();
  }

  /// This method call an api to get all country list from server and
  /// Update [countryModel] data model with new value
  getCountryMethod() async {
    try {
      CountryModel temp = CountryModel();
      await temp.callApi();
      countryModelRx.value = temp;
      print(countryModelRx.value?.data?.length);

      update();
    } catch (e) {
      print('error = $e');
    }
  }
}

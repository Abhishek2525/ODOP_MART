import 'package:get/get.dart';

import '../view_models/country_view_model.dart';

class CountryBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(CountryViewModel());
  }
}

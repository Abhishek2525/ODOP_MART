import 'package:get/get.dart';

import '../../view_models/search/search_view_model.dart';

class SearchBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchViewModel());
  }
}

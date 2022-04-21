import 'package:get/get.dart';

import '../view_models/genre_view_model.dart';

class GenrePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(GenreViewModel());
  }
}

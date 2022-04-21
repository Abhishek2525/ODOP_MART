import 'package:get/get.dart';

import '../view_models/actor_view_model.dart';

class ActorPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ActorViewModel());
  }
}

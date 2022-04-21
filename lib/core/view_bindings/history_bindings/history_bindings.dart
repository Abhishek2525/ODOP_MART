import 'package:get/get.dart';

import '../../view_models/history_view_model/history_view_model.dart';
import '../../view_models/video_view_view_model.dart';

class HistoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HistoryViewModel());
    Get.put(VideoViewViewModel());
  }
}

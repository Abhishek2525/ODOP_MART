import 'package:get/get.dart';
import 'package:iotflixcinema/core/utils/local_auth/local_auth_get_storage.dart';
import 'package:iotflixcinema/view/pages/premium_video_warning_page/premium_video_warning_page.dart';

class PremiumVideoServices{

  static bool userIsAPremiumUser(){
    int activePackage = LocalDBUtils.getActivePackageId();
    if(activePackage != -1){
      return true;
    }else{
      Get.to(PremiumVideoWarningPage());
      return false;
    }
  }
}
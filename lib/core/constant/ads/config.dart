import 'dart:io';

//import 'package:advertising_id/advertising_id.dart';
import 'package:device_info/device_info.dart';

class AppDeviseInfo {
  /// This method return the device ID with the help of
  /// [DeviceInfoPlugin] plugin
  getInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      print('Running on ${androidInfo.androidId}'); // e.g. "Moto G (4)"
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
    }
  }

  /// get the advertising id
  getAAID() async {
    // String advertisingId;
    //
    // /// Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   advertisingId = await AdvertisingId.id(true);
    //   print(advertisingId);
    // } catch (e) {
    //   advertisingId = 'Failed to get platform version.';
    // }
  }
}

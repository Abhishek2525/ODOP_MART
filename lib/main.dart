

import 'dart:typed_data';

//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get_storage/get_storage.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'core/constant/storage_constant.dart';
import 'core/downloader/app_dowbloader.dart';
import 'core/downloader/models.dart';
import 'core/middle_ware/route_objerver.dart';
import 'core/theme/theme.dart';
import 'core/utils/keep_watching_db_util/keep_watching_db.dart';
import 'core/view_bindings/initial_bindings.dart';
import 'core/view_models/ads/ads_view_model.dart';
import 'core/view_models/theme_view_model.dart';
import 'view/constant/constant_base64_images.dart';
import 'view/pages/splash/SplashScreen.dart';
import 'view/router/app_navigator.dart';

Uint8List drawerImage;

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterBackgroundService service = FlutterBackgroundService();
  service.setForegroundMode(false);

  service.onDataReceived.listen(
    (event) async {
      print("Back ground event --> $event");
      if (event['action'] == "download") {
        print(event['data']);
        print(event['data'].runtimeType);

        DownloadData data = DownloadData.fromJson(event['homeData']);
        TaskInfo loadedTask = TaskInfo.fromJson(event['taskInfo']);
        await AppDownloader.getInstance.init(debug: true);
        TaskInfo temp =
            await AppDownloader.getInstance.encryptDownloadedFile(loadedTask);
        if (temp != null) {
          // await AppDownloader.getInstance.saveDownloadFileData(data, temp);dash
          service.sendData(
            {
              "downloadComplete": true,
              "homeData": data.toJson(),
              "taskInfo": temp.toJson(),
            },
          );

          // AppDownloader.getInstance.downloadedCallback?.call(temp);
        }
      } else if (event['action'] == "decrypt") {
        String video = event['videoPath'];
        // await EncryptData.loadKey();
        // String videoData = EncryptData.decryptFile(video);

        DateTime now = DateTime.now();

        String videoData = await AppDownloader.getInstance.decryptFile(video);

        Duration duration = DateTime.now().difference(now);
        print("decrypt time ${duration.inMilliseconds} inMilliseconds");

        print("decrypt successful :==> $videoData ");
        service.sendData(
          {
            "decryptComplete": true,
            "video": videoData,
          },
        );
      }
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  drawerImage = Base64Images.getDrawerImg();
  await AppDownloader.getInstance.init(debug: true);
  await AppDownloader.getInstance.onStart();

  //TODO: must remove the comment for enable background service
  bool isRunning = await FlutterBackgroundService().isServiceRunning();
  print('FlutterBackgroundService working :=> $isRunning');
  // if (!isRunning) {
  //   await FlutterBackgroundService.initialize(onStart);
  // }
  //FlutterBackgroundService.initialize(onStart);

  /// ads
  Get.put(AdsViewModel());
  if (kIsWeb) {
  } else {
    //Admob.initialize();
   // MobileAds.instance.initialize();
  }

  /// initialize the theme controller
  Get.lazyPut<ThemeController>(() => ThemeController());

  /// initialize GetStorage
  await GetStorage.init();
  await GetStorage.init(StorageConstant.authStorage);
  await KeepWatchingDB.ins.init();
  //
  // if (!kIsWeb) {
  //   //TODO: Remove this method to stop OneSignal Debugging
  //   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  //
  //   /// Initialize OneSignal
  //   OneSignal.shared.setAppId("1d5ea9aa-5859-4944-8975-62a2bb68497c");
  //   OneSignal.shared
  //       .promptUserForPushNotificationPermission()
  //       .then((accepted) {});
  //
  //   /// The promptForPushNotificationsWithUserResponse function will show the
  //   /// iOS push notification prompt. We recommend removing the following code
  //   /// and instead using an In - App Message to prompt for notification permission
  //   await OneSignal.shared
  //       .promptUserForPushNotificationPermission(fallbackToSettings: true);
  //
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     var _debugLabelString =
  //         "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
  //
  //     print(_debugLabelString);
  //   });
  // }

  /// Set up default App Orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

/// Responsible for Observe app routing
class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {}

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromPreferences();
    return GetMaterialApp(
      routingCallback: (routing) {
        AdsMiddleWare.clickCountIncrement();
      },
      initialBinding: InitialBindings(),
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      defaultTransition: Transition.fadeIn,
      darkTheme: CustomTheme.darkTheme,
      home: SplashScreen(),
      navigatorObservers: [MyRouteObserver()],
      getPages: AppPageNavigator.getPages,
    );
  }
}

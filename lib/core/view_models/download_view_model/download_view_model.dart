import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';

import '../../downloader/app_dowbloader.dart';
import '../../downloader/models.dart';
import '../../models/home_categories_model.dart';

class DownloadViewModel extends GetxController {
  @override
  void onInit() {
    init();
    super.onInit();
  }

  init() async {
    await AppDownloader.getInstance.onStart();
    getDownloadedList();
  }

  @override
  void onClose() {
    AppDownloader.getInstance.onClose();
    super.onClose();
  }

  getDownloadedList() async {
    downloadedList = await AppDownloader.getInstance.getDownloadList();
    print("downloadedList :=>${downloadedList.length}");
    update();
  }

  saveData() {}

  addToDownload(HomeData d) async {
    // FlutterBackgroundService().sendData({"action": "download", "data": d.toJson()});

    AppDownloader.getInstance.addToDownload(d,
        downloadedCallback: (TaskInfo t) {
      // print("download status :=> ${t.toJson()}");
      // getDownloadedList();
    });
    // AppDownloader.onDownloadCallBack = (TaskInfo t) {
    //   print("downloaded status :=> ${t.status}");
    //   getDownloadedList();
    // };
    //  FlutterBackgroundService().setAutoStartOnBootMode(true);
    // bool isRunning = await FlutterBackgroundService().isServiceRunning();
    // if (!isRunning) {
    //   await FlutterBackgroundService.initialize(onStart);
    // }
    FlutterBackgroundService().onDataReceived.listen(
      (event) async {
        if (event['downloadComplete'] == true) {
          print("event callback : $event");
          DownloadData data = DownloadData.fromJson(event['homeData']);
          TaskInfo loadedTask = TaskInfo.fromJson(event['taskInfo']);
          await AppDownloader.getInstance
              .saveDownloadFileData(data, loadedTask);

          getDownloadedList();
        }
      },
    );
  }

  bool isDownloaded(int id) {
    DownloadedDataModel data = downloadedList.firstWhere(
        (DownloadedDataModel element) => element.data.id == id,
        orElse: () => null);
    return data != null;
  }

  List<DownloadedDataModel> downloadedList = <DownloadedDataModel>[];
}

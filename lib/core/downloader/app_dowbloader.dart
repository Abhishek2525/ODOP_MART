import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/home_categories_model.dart';
import 'encrypt/encrypt_with_null_sefty.dart';
import 'models.dart';

class AppDownloader {
  bool isLoading;
  bool _permissionReady;
  String _localPath;
  ReceivePort _port = ReceivePort();
  bool debug = false;
  Map<String, bool> onEncrypting = <String, bool>{};

  Map<String, bool> downloadUrl = <String, bool>{};

  List<DownloadedDataModel> downloadedList = <DownloadedDataModel>[];

  Future<List<DownloadedDataModel>> getDownloadList() async {
    //await _prepare();

    return downloadedList;
  }

  AppDownloader._() {
    _instance = this;
  }

  static AppDownloader _instance; //= AppDownloader._();

  static AppDownloader get getInstance => _instance ?? AppDownloader._();

  Future<void> init({bool debug = true}) async {
    try {
      await GetStorage.init("downloadedFiles");
      this.debug = debug;
      //await FlutterDownloader.initialize(debug: debug);
    } catch (e, t) {
      print(e);
      print(t);
    }
  }

  onClose() async {
    _unbindBackgroundIsolate();
  }

  /// return vimeo platform's video ID from Vimeo video url
  String getVimoId(String url) {
    String id = url.split('/').last;
    return id;
  }

  /// Check Whether a video is from [Vimeo] Platform or not from its URl
  isVimoUrl(String url) {
    return url.contains('vimeo.com/');
  }

  Future<String> idVimoVideo(String url) async {
    http.Response response = await http.get(Uri.parse(
        'https://player.vimeo.com/video/' + getVimoId(url) + '/config'));
    var jsonData = jsonDecode(response.body)['request']['files']['progressive'];

    if (jsonData is List) {
      if (jsonData.length > 0) {
        return jsonData.last['url'];
      }
    }

    return null;
  }

  onStart() async {
    //_bindBackgroundIsolate();

    //FlutterDownloader.registerCallback(downloadCallback);
    isLoading = true;
    _permissionReady = false;

    // List<DownloadTask> downloadList = await _prepare();
    // for (int i = 0; i < (downloadList?.length ?? 0); i++) {
    //   if (downloadList[i].status != DownloadTaskStatus.complete) {
    //     TaskInfo t = TaskInfo(
    //       link: downloadList[i].url,
    //     );
    //     t.taskId = downloadList[i].taskId;
    //     delete(t);
    //     // retryDownload(t);
    //   }
    // }
  }

  // ignore: missing_return
  Future<String> addToDownload(
    HomeData data, {
    Function(TaskInfo temp) downloadedCallback,
  }) async {
    print("addToDownload");
    if (data == null) return "download failed";

    print("download started");
    String videoUrl = data.videoUrl ?? "";

    print(">- -- -- -- -- -- -- -- -->");
    print(videoUrl);
    print(downloadUrl[videoUrl]);
    print(">- -- -- -- -- -- -- -- -->");
    if (downloadUrl[videoUrl] == true) {
      print("Already downloaded  <- --- -- -- -->");
      return "already Download";
    }

    downloadUrl[videoUrl] = true;
    print(downloadUrl[videoUrl]);
    print(">- -- -- -- -- -- -- -- -->");

    if (videoUrl.contains('https:')) {
      videoUrl = videoUrl;
    } else {
      videoUrl = videoUrl.replaceFirst('http:', 'https:');
    }

    if (isVimoUrl(videoUrl)) {
      String url = await idVimoVideo(videoUrl);
      videoUrl = url != null ? url : videoUrl;
      //print("vimo url:-> $videoUrl");
    }

    TaskInfo t = TaskInfo(
      link: videoUrl,
      name: data.title,
    );

    // List<DownloadTask> downloadList = await _prepare();
    //
    // for (int i = 0; i < (downloadList?.length ?? 0); i++) {
    //   if (downloadList[i].url == videoUrl ||
    //       downloadList[i].filename == data.title) {
    //     t.taskId = downloadList[i].taskId;
    //     await delete(t);
    //   }
    // }

    await retryRequestPermission();
    print("download:=> $videoUrl ");
    TaskInfo loadedTask = await requestDownload(t);

    print("download taskInfo ${loadedTask.toJson()}");

    _bindBackgroundIsolate(process: (TaskInfo tf) async {
      try {
        if (true) {
          print('taskInfoStream Callback: $tf');
        }
        String id = tf.taskId;
      //  DownloadTaskStatus status = tf.status;
        int progress = tf.progress;

        print("$id == ${loadedTask.taskId} ");
        if (id == loadedTask.taskId) {
          //loadedTask.status = status;
          loadedTask.progress = progress;

          if (loadedTask.progress == 100) {
            if (onEncrypting[loadedTask.taskId] == true) {
              return null;
            }
            onEncrypting[loadedTask.taskId] = true;
            // bool isRunning = await FlutterBackgroundService().isServiceRunning();
            // print("FlutterBackgroundService on addToDownload $isRunning");
            // if (!isRunning) {
            //   await FlutterBackgroundService.initialize(onStart);
            // }
            FlutterBackgroundService().sendData({
              "action": "download",
              "homeData": data.toJson(),
              "taskInfo": loadedTask.toJson(),
            });

            // TaskInfo temp = await encriptDownloadedFile(loadedTask);
            // if (temp != null) {
            //   saveDownloadFileData(data, temp);
            //   downloadedCallback?.call(temp);
            // }
          }
        }
      } catch (e, t) {
        print(e);
        print(t);
      }
    });
  }

  void _bindBackgroundIsolate({Function(TaskInfo) process}) {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate(process: process);
      return;
    }
    _port.listen((dynamic data) {
      if (true) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      //DownloadTaskStatus status = data[1];
      int progress = data[2];

      TaskInfo temp = TaskInfo(
        taskId: id,
        status: null,//status
        progress: progress,
      );

      if (progress == 100) process?.call(temp);
    });
  }

  getDownloadedData(String key) async {
    await GetStorage.init("downloadedFiles");
    GetStorage g = GetStorage("downloadedFiles");

    String s = g.read(key);
    return s;
  }

  saveDownloadFileData(HomeData data, TaskInfo loadedTask) async {
    GetStorage g = GetStorage("downloadedFiles");
    DownloadedDataModel d = DownloadedDataModel(
      data: data,
      task: loadedTask,
    );

    print(d.toString());
    print("saved downloaded file:=> ${loadedTask.taskId}");
    await g.write(loadedTask.taskId, d.toString());
    g.writeInMemory(loadedTask.taskId, d.toString());
    await g.save();
    print("saved downloaded file:=> ${g.read(loadedTask.taskId)}  successful");
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  // Future<List<DownloadTask>> _prepare() async {
  //   final List<DownloadTask> tasks = await FlutterDownloader.loadTasks();
  //
  //   // print("download loaded length ${tasks?.length} =============>");
  //
  //   for (int i = 0; i < (tasks.length ?? 0); i++) {
  //     var element = tasks[i];
  //
  //     print(element.toString());
  //     String s = await getDownloadedData(element.taskId);
  //     print("-----");
  //     print(s);
  //     if (s == null || s == "") continue;
  //     Map<String, dynamic> map = json.decode(s);
  //     DownloadedDataModel m = DownloadedDataModel.fromJson(map);
  //     if (m.isExistFile()) {
  //       if (!this.downloadedList.contains(m)) {
  //         this.downloadedList.add(m);
  //       }
  //     } else {
  //       //delete(m?.task);
  //     }
  //   }
  //
  //   //print("download loaded:=============>");
  //   print("downloadedList len :=>${downloadedList.length}");
  //   //int count = 0;
  //
  //   _permissionReady = await _checkPermission();
  //
  //   if (_permissionReady) {
  //     await _prepareSaveDir();
  //   }
  //   isLoading = false;
  //
  //   return tasks;
  // }

  static void downloadCallback(
      String id, var status, int progress) { //DownloadTaskStatus
    if (true) {
      print(
          'Background Iso Callback: task ($id) is in status ($status) and process ($progress)');
    }

    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        // final directory = await getExternalStorageDirectory();
        // externalStorageDirPath = directory?.path;
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
        print("android Download path $externalStorageDirPath");
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<bool> _checkPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }
    _permissionReady = hasGranted;
  }

  Future<TaskInfo> requestDownload(TaskInfo task) async {
    // task.name = "test.mp4";
    DateTime now = DateTime.now();
    print("download time start $now");
    // task.taskId = await FlutterDownloader.enqueue(
    //   url: task.link,
    //   headers: {"auth": "test_for_sql_encoding"},
    //   savedDir: _localPath,
    //   showNotification: true,
    //   fileName: task.name,
    //   openFileFromNotification: false,
    // );

    //  print("download time end ${DateTime.now().difference(now).inMilliseconds}");

    //  print("${task.name} downloaded ---------------- ->");
    String downloadedPath =
        _localPath + "/" + task.name; //+ "." + task.link.split('.').last;
    // print("file path :--> '$downloadedPath'");
    task.downloadedPath = downloadedPath;
    return task;
  }

  Future<TaskInfo> encryptDownloadedFile(TaskInfo task) async {
    print("encryptDownloadedFile called");
    try {
      String downloadedPath = task.downloadedPath;
      // if (onEncrypting[task.taskId] == true) {
      //   return null;
      // }
      if (downloadedPath.endsWith(".aes")) {
        return null;
      }
      //  onEncrypting[task.taskId] = true;
      bool b = await File(downloadedPath).exists();
      print("file existsSync :--> $b");

      // String encryptedPath = await EncryptData.encryptFile(downloadedPath);
      String encryptedPath = await AppEncrypt.encryptFile(downloadedPath);
      await Future.delayed(Duration(milliseconds: 10));
      print("encrypted path :--> '$encryptedPath' ");

      if (encryptedPath != null || encryptedPath != "") {
        FileSystemEntity t = await File(downloadedPath).delete();
        t.existsSync();
        bool bb = await File(downloadedPath).exists();
        print('$bb');
        print("file deleted :${t.existsSync()} --> ");
      }

      task.downloadedPath = encryptedPath;
      //onEncrypting[task.taskId] = false;
      return task;
    } catch (e, t) {
      print(e);
      print(t);
      print("encript execption");
    }

    return null;
  }

  Future<String> decryptFile(String path) async {
    await AppEncrypt.loadKey();
    String f = await AppEncrypt.decryptFile(path);
    return f;
  }

  void cancelDownload(TaskInfo task) async {
  //  await FlutterDownloader.cancel(taskId: task.taskId);
  }

  void pauseDownload(TaskInfo task) async {
  //  await FlutterDownloader.pause(taskId: task.taskId);
  }

  void resumeDownload(TaskInfo task) async {
    //String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    //task.taskId = newTaskId;
  }

  void retryDownload(TaskInfo task) async {
   // String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
   // task.taskId = newTaskId;
  }

  Future<bool> openDownloadedFile(TaskInfo task) {
    if (task != null) {
    //  return FlutterDownloader.open(taskId: task.taskId);
      return Future.value(false);
    } else {
      return Future.value(false);
    }
  }

  Future<void> delete(TaskInfo task) async {
    // await FlutterDownloader.remove(
    //   taskId: task.taskId,
    //   shouldDeleteContent: true,
    // );
    // await _prepare();
  }

  Future<bool> onPlayerDispose(String path) async {
    try {
      print("onPlayerDispose deleted called");
      if (path.startsWith("http")) return false;
      if (path != null || path != "") {
        bool fileExist = await File(path).exists();
        if (fileExist == true) {
          FileSystemEntity t = await File(path).delete();
          t.existsSync();
          bool bb = await File(path).exists();
          print('$bb');
          print("file deleted : <-> ${t.existsSync()} --> ");
          return true;
        }
      }
    } catch (e, t) {
      print('$e');
      print('$t');
    }
    return false;
  }
}

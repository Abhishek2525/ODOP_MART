import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BasicPlayerPage extends StatefulWidget {
  final String video;

  BasicPlayerPage(this.video);

  @override
  _BasicPlayerPageState createState() => _BasicPlayerPageState();
}

class _BasicPlayerPageState extends State<BasicPlayerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  BetterPlayerController controller;

  init() async {
    FlutterBackgroundService().sendData(
      {
        "action": "decrypt",
        "videoPath": widget.video,
      },
    );

    bool isRunning = await FlutterBackgroundService().isServiceRunning();
    print('$isRunning');
    // if (!isRunning) {
    //   await FlutterBackgroundService.initialize(onStart);
    // }
    FlutterBackgroundService().onDataReceived.listen(
      (event) async {
        if (event['decryptComplete'] == true) {
          print("decrypt callback : $event");
          print(event['video'].runtimeType);
          String video = event['video']?.toString();

          if (video == null || video?.length == 0) return;

          BetterPlayerDataSource s = BetterPlayerDataSource.file(video);
          controller = BetterPlayerController(
            BetterPlayerConfiguration(
              autoPlay: true,
            ),
            betterPlayerDataSource: s,
          );

          if (mounted) {
            setState(() {});
          }
        }
      },
    );

//Uint8List video = await
//
//     BetterPlayerDataSource s = BetterPlayerDataSource.memory(video);
//     controller = BetterPlayerController(
//       BetterPlayerConfiguration(
//         autoPlay: true,
//       ),
//       betterPlayerDataSource: s,
//     );
//
//     setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          bool isRunning = await FlutterBackgroundService().isServiceRunning();
          if (isRunning) {
            FlutterBackgroundService().stopBackgroundService();
          }


          if (controller != null) {
            controller.pause();
          }
        } catch (e) {}
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Basic player"),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Basic player created with the simplest factory method. Shows video from URL.",
                style: TextStyle(fontSize: 16),
              ),
            ),

            AspectRatio(
              aspectRatio: 16 / 9,
              child: (controller != null)
                  ? BetterPlayer(
                      controller: controller,
                    )
                  : Container(
                      child: Center(child: Text("decrypting")),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Next player shows video from file.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            // FutureBuilder<String>(
            //   future: Utils.getFileUrl(Constants.fileTestVideoUrl),
            //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //     if (snapshot.data != null) {
            //       return BetterPlayer.file(snapshot.data!);
            //     } else {
            //       return const SizedBox();
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print('\n\n-----------noffline video deactivated--------------\n\n');
    if (controller != null) {
      controller.pause();
      controller.dispose(forceDispose: true);
    }

    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}

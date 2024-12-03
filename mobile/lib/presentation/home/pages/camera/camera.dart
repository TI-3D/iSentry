import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isRecording = false;
  String activeButton = "Photo";
  late VlcPlayerController _vlcViewController;

  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _initVlcPlayer();
    _startClock();
    _requestStoragePermission();
  }

  Future<void> _initVlcPlayer() async {
    _vlcViewController = VlcPlayerController.network(
      "rtsp://192.168.25.215:8554/test",
      autoPlay: true,
    );
  }

  Future<void> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      print("Storage permission granted");
    } else {
      print("Storage permission denied");
    }
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = _formatCurrentTime();
      });
    });
  }

  String _formatCurrentTime() {
    DateTime now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _vlcViewController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff18181b),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.keyboard_arrow_left_outlined,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.6001,
                width: MediaQuery.sizeOf(context).width * 1,
                child: VlcPlayer(
                  controller: _vlcViewController,
                  aspectRatio: 16 / 9,
                  placeholder: const Center(child: CircularProgressIndicator()),
                ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                color: const Color(0xff18181b),
                padding: const EdgeInsets.only(bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff27272a),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        "$_currentTime WIB",
                        style: const TextStyle(
                            color: Color(0xffa1a1aa),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xff27272a),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  activeButton = "Photo";
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: activeButton == "Photo"
                                      ? const Color(0xff18181b)
                                      : const Color(0xff3d3d43),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                child: Text(
                                  "Photo",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: activeButton == "Video"
                                        ? Colors.grey
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  activeButton = "Video";
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: activeButton == "Video"
                                      ? const Color(0xff18181b)
                                      : const Color(0xff3d3d43),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 2),
                                child: Text(
                                  "Video",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: activeButton == "Video"
                                        ? Colors.white
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Color(0xff18181b),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: const Icon(
                                  Icons.file_present_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (activeButton == 'Photo') {
                                  try {
                                    final Uint8List snapshotData =
                                        await _vlcViewController.takeSnapshot();

                                    final directory =
                                        await getExternalStorageDirectory();
                                    if (directory == null) {
                                      print(
                                          "Could not retrieve the storage directory.");
                                      return;
                                    }

                                    final filePath = join(directory.path,
                                        'snapshot_${DateTime.now().millisecondsSinceEpoch}.jpg');

                                    final file = File(filePath);
                                    await file.writeAsBytes(snapshotData);

                                    print('Snapshot saved at: $filePath');
                                  } catch (e) {
                                    print('Error occurred: $e');
                                  }
                                }
                                // else if (!isRecording) {
                                //   try {
                                //     final directory =
                                //         await getExternalStorageDirectory();
                                //     if (directory == null) {
                                //       print(
                                //           "Could not retrieve the storage directory.");
                                //       return;
                                //     }
                                //     final recordingDirectory = Directory(
                                //         join(directory.path, 'records'));
                                //     if (!await recordingDirectory.exists()) {
                                //       await recordingDirectory.create(
                                //           recursive: true);
                                //     }
                                //     final filePath = join(
                                //         recordingDirectory.path,
                                //         'recording_${DateTime.now().millisecondsSinceEpoch}.mp4');

                                //     final success = await _vlcViewController
                                //         .startRecording(filePath);

                                //     if (success != null && success) {
                                //       setState(() {
                                //         isRecording = true;
                                //       });
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(
                                //         const SnackBar(
                                //             content: Text("Recording started")),
                                //       );
                                //     } else {
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(
                                //         const SnackBar(
                                //             content: Text(
                                //                 "Failed to start recording")),
                                //       );
                                //     }
                                //   } catch (e) {
                                //     print("Error occurred: $e");
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //           content: Text(
                                //               "An error occurred while starting the recording")),
                                //     );
                                //   }
                                // } else {
                                //   final recordingPath =
                                //       await _vlcViewController.stopRecording();
                                //   setState(() {
                                //     isRecording = false;
                                //   });

                                //   if (recordingPath != null) {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(
                                //           content: Text(
                                //               "Recording saved at $recordingPath")),
                                //     );
                                //   } else {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //           content:
                                //               Text("Failed to save recording")),
                                //     );
                                //   }
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(1),
                              ),
                              child: Stack(
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    size: 85,
                                    color: Color(0xff18181b),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      child: Icon(Icons.circle,
                                          size: 78,
                                          color: activeButton == 'Video'
                                              ? const Color(0xff7f1d1d)
                                              : Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              enableFeedback: false,
                              icon: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Color(0xff27272a),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: const Icon(
                                  Icons.file_present_outlined,
                                  color: Color(0xff27272a),
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

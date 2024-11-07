import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;

  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _initCamera();
    _startClock();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    await _controller.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
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
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _stopCamera() async {
    if (_controller.value.isInitialized) {
      await _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff18181b),
        leading: IconButton(
          onPressed: () async {
            await _stopCamera();
            // ignore: use_build_context_synchronously
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
                height: MediaQuery.sizeOf(context).height * 0.6,
                width: MediaQuery.sizeOf(context).width * 1,
                child: _isCameraInitialized
                    ? CameraPreview(_controller)
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Container(
                height: 60,
                width: double.infinity,
                color: const Color(0xff18181b),
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xff27272a),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        "$_currentTime PM",
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
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xff3d3d43),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: const Text(
                                "Photo",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xffdcdfe4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xff18181b),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: const Text(
                                "Video",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xfff1f4f9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                padding: const EdgeInsets.all(10),
                                child: const Icon(
                                  Icons.file_present_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Implementasi aksi seperti mengambil gambar di sini
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(1),
                              ),
                              child: const Stack(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 85,
                                    color: Color(0xff18181b),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      child: Icon(Icons.circle,
                                          size: 78, color: Color(0xff7f1d1d)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: Color(0xff27272a),
                                ),
                                padding: const EdgeInsets.all(10),
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

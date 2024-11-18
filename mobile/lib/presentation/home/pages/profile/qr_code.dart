import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrCodePage extends StatelessWidget {
  final String userName;
  QrCodePage({super.key, required this.userName});

  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _shareQRCode() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/qr_code.png';
    final capture = await _screenshotController.capture();
    if (capture == null) {
      return;
    }

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(capture);
    await Share.shareXFiles([XFile(imagePath)], text: "Share QR Code");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'QR CODE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      child: QrImageView(
                        data: userName,
                        version: QrVersions.auto,
                        size: 260,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _shareQRCode,
            icon: const Icon(Icons.share),
            label: const Text("Share QR Code"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

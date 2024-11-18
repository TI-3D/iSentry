import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isentry/core/configs/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({super.key});

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final TextEditingController _textController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  String qrData = '';
  String selectedType = 'text';
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
    'url': TextEditingController(),
  };

  String _generateQRData() {
    switch (selectedType) {
      case 'contact':
        return '''BEGIN:VCARD
        VERSION:3.0
        FN:${_controllers['name']?.text}
        TEL:${_controllers['phone']?.text}
        EMAIL:${_controllers['email']?.text}
        END:VCARD''';

      case 'url':
        String url = _controllers['url']?.text ?? '';
        if (!url.startsWith('http://') && !url.startsWith('https://')) {
          url = 'http://$url';
        }
        return url;

      default:
        return _textController.text;
    }
  }

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

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        onChanged: (_) {
          setState(() {
            qrData = _generateQRData();
          });
        },
      ),
    );
  }

  Widget _buildInputField() {
    switch (selectedType) {
      case 'contact':
        return Column(
          children: [
            _buildTextField(_controllers['name']!, "Name"),
            _buildTextField(_controllers['phone']!, "Phone"),
            _buildTextField(_controllers['email']!, "Email"),
          ],
        );

      case 'url':
        return _buildTextField(_controllers['url']!, "URL");
      default:
        return TextField(
          controller: _textController,
          decoration: InputDecoration(
              labelText: "Enter Text",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          onChanged: (value) {
            setState(() {
              qrData = value;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SegmentedButton<String>(
                        selected: {selectedType},
                        onSelectionChanged: (Set<String> selection) {
                          setState(
                            () {
                              selectedType = selection.first;
                              qrData = '';
                            },
                          );
                        },
                        segments: const [
                          ButtonSegment(
                            value: 'text',
                            label: Text("Text"),
                            icon: Icon(Icons.text_fields),
                          ),
                          ButtonSegment(
                            value: 'url',
                            label: Text("URL"),
                            icon: Icon(Icons.text_fields),
                          ),
                          ButtonSegment(
                            value: 'contact',
                            label: Text("Contact"),
                            icon: Icon(Icons.contact_page),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (qrData.isNotEmpty)
                Column(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Screenshot(
                              controller: _screenshotController,
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(16),
                                child: QrImageView(
                                  data: qrData,
                                  version: QrVersions.auto,
                                  size: 200,
                                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

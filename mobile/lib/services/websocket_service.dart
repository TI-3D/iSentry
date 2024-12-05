import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isentry/services/notification_service.dart';
import 'package:isentry/utils/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static WebSocketChannel? _channel;

  static void connect(BuildContext context) async {
    try {

      _channel = WebSocketChannel.connect(Uri.parse(websocketUrl)); // Menggunakan konstanta
      await _channel?.ready;
      _channel?.stream.listen((message) {
        print("Message from server: $message");

        // Tampilkan notifikasi lokal
        NotificationService.showNotification("Wajah Terdeteksi", message);
      }, onError: (error) {
          print("WebSocket error: $error");
        }, onDone: () {
          print("WebSocket connection closed");
        });
    } on WebSocketException catch (e) {
      print("Error hah: $e");
    } on WebSocketChannelException catch (e) {
      print("lah: ${e.message}");
    }
  }

  void disconnect() {
    _channel?.sink.close();
  }
}

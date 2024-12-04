import 'package:flutter/material.dart';
import 'package:isentry/services/notification_service.dart';
import 'package:isentry/utils/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  void connect(BuildContext context) {
    _channel = WebSocketChannel.connect(Uri.parse(websocketUrl)); // Menggunakan konstanta
    _channel?.stream.listen((message) {
      print("Message from server: $message");

      // Tampilkan notifikasi lokal
      NotificationService.showNotification("Wajah Terdeteksi", message);
    }, onError: (error) {
      print("WebSocket error: $error");
    }, onDone: () {
      print("WebSocket connection closed");
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}

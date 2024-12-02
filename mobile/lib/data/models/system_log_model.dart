class SystemLog {
  final int id;
  final DateTime timestamp;
  final String message;

  SystemLog({
    required this.id,
    required this.timestamp,
    required this.message,
  });

  factory SystemLog.fromJson(Map<String, dynamic> json) {
    return SystemLog(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
    };
  }
}

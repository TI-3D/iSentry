class DetectionLog {
  final int id;
  final DateTime timestamp;
  final int faceId;

  DetectionLog({
    required this.id,
    required this.timestamp,
    required this.faceId,
  });

  factory DetectionLog.fromJson(Map<String, dynamic> json) {
    return DetectionLog(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      faceId: json['face'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'face': faceId,
    };
  }
}

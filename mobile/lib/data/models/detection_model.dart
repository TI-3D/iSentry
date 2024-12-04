import 'package:isentry/domain/entities/detection.dart';

class DetectionModel extends Detection {
  DetectionModel({
    required super.id,
    required super.faceId,
    required super.timestamp,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    final timestampString = json['timestamp'] as String;
    final timestampDate = DateTime.parse(timestampString);

    return DetectionModel(
      id: json['id'] as int,
      timestamp: DateTime(timestampDate.year, timestampDate.month,
          timestampDate.day, timestampDate.hour, timestampDate.minute),
      faceId: json['face'] as int,
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

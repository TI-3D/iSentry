class DetectionDetailModel {
  final int id;
  final DateTime timestamp;
  final int faceId;
  final int? identityId;
  final String? identityName;
  final bool isRecognized;

  const DetectionDetailModel({
    required this.id,
    required this.faceId,
    required this.identityId,
    required this.identityName,
    required this.timestamp,
    required this.isRecognized,
  });

  factory DetectionDetailModel.fromJson(
      Map<String, dynamic> json, bool recognized) {
    final timestampString = json['timestamp'] as String;
    final timestampDate = DateTime.parse(timestampString);

    return DetectionDetailModel(
      id: json['id'] as int,
      faceId: json['face'] as int,
      identityId: json['faceRelation']['identity'] as int?,
      identityName: json['faceRelation']['identities']?['name'] as String?,
      timestamp: DateTime(timestampDate.year, timestampDate.month,
          timestampDate.day, timestampDate.hour, timestampDate.minute),
      isRecognized: recognized,
    );
  }
}

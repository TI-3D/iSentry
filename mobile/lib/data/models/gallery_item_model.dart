class GalleryItem {
  final int id;
  final String path;
  final ItemType type;
  final CaptureMethod captureMethod;
  final DateTime createdAt;
  final DateTime updatedAt;

  GalleryItem({
    required this.id,
    required this.path,
    required this.type,
    required this.captureMethod,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'],
      path: json['path'],
      type: ItemType.values.byName(json['type']),
      captureMethod: CaptureMethod.values.byName(json['capture_method']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'type': type.name,
      'capture_method': captureMethod.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

enum ItemType {
  // ignore: constant_identifier_names
  PICTURE,
  // ignore: constant_identifier_names
  VIDEO,
}

enum CaptureMethod {
  // ignore: constant_identifier_names
  AUTO,
  // ignore: constant_identifier_names
  MANUAL,
}

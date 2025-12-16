class FruitImage {
  final int? id;
  final String name;
  final int familyId;
  final String? file;
  final String? fileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FruitImage({
    this.id,
    required this.name,
    required this.familyId,
    this.file,
    this.fileUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory FruitImage.fromJson(Map<String, dynamic> json) {
    return FruitImage(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      name: json['name'] ?? '',
      familyId: json['family_id'] != null
          ? int.tryParse(json['family_id'].toString()) ?? 0
          : 0,
      file: json['file'],
      fileUrl: json['file_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'family_id': familyId,
      'file': file,
      'file_url': fileUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

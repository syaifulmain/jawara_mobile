class Broadcast {
  final int? id;
  final String title;
  final String message;
  final DateTime? publishedAt;
  final int? createdBy;
  final String? creatorName;
  final String? photo;
  final String? photoUrl;
  final String? document;
  final String? documentUrl;

  Broadcast({
    this.id,
    required this.title,
    required this.message,
    this.publishedAt,
    this.createdBy,
    this.creatorName,
    this.photo,
    this.photoUrl,
    this.document,
    this.documentUrl,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) {
    return Broadcast(
      id: json['id'] as int?,
      title: json['title'] as String,
      message: json['message'] as String,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdBy: json['created_by'] as int?,
      creatorName: json['creator_name'] as String?,
      photo: json['photo'] as String?,
      photoUrl: json['photo_url'] as String?,
      document: json['document'] as String?,
      documentUrl: json['document_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'published_at': publishedAt?.toIso8601String(),
      'created_by': createdBy,
      'creator_name': creatorName,
      'photo': photo,
      'photo_url': photoUrl,
      'document': document,
      'document_url': documentUrl,
    };
  }

  Broadcast copyWith({
    int? id,
    String? title,
    String? message,
    DateTime? publishedAt,
    int? createdBy,
    String? creatorName,
    String? photo,
    String? photoUrl,
    String? document,
    String? documentUrl,
  }) {
    return Broadcast(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      publishedAt: publishedAt ?? this.publishedAt,
      createdBy: createdBy ?? this.createdBy,
      creatorName: creatorName ?? this.creatorName,
      photo: photo ?? this.photo,
      photoUrl: photoUrl ?? this.photoUrl,
      document: document ?? this.document,
      documentUrl: documentUrl ?? this.documentUrl,
    );
  }
}

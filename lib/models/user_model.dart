class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool is_active;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.is_active,
    this.photoUrl,
  });

  bool get isAdmin => role == 'admin';
  bool get isActive => is_active;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      is_active: json['is_active'] ?? false,
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'is_active': is_active,
      'photo_url': photoUrl,
    };
  }
}

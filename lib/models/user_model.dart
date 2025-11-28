import '../enums/user_role.dart';

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

  // Helper methods untuk akses menu
  UserRole get userRole => UserRole.fromString(role);

  bool get isAdmin => userRole == UserRole.admin;
  bool get isRT => userRole == UserRole.rt;
  bool get isRW => userRole == UserRole.rw;
  bool get isBendahara => userRole == UserRole.bendahara;
  bool get isSekretaris => userRole == UserRole.serketaris;
  bool get isUser => userRole == UserRole.user;

  // Akses penuh (admin, rt, rw)
  bool get hasFullAccess => isAdmin || isRT || isRW;

  // Akses fitur keuangan
  bool get canAccessFinance => hasFullAccess || isBendahara;

  // Akses fitur kegiatan
  bool get canAccessActivity => hasFullAccess || isSekretaris;

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

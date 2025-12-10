class UserDetailModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;
  final String? photoUrl;

  UserDetailModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
    this.photoUrl
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'user',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'photo_url': photoUrl,
    };
  }
}

class UserListModel {
  final int id;
  final String name;
  final String email;
  final String isActive;

  UserListModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? 'Tidak Aktif',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'is_active': isActive,
    };
  }
}

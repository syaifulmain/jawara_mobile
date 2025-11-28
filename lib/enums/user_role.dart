enum UserRole {
  admin('admin', 'Administrator'),
  user('user', 'User'),
  rt('rt', 'Rukun Tetangga'),
  rw('rw', 'Rukun Warga'),
  bendahara('bendahara', 'Bendahara'),
  serketaris('sekretaris', 'Sekretaris');

  final String value;
  final String label;

  const UserRole(this.value, this.label);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
          (category) => category.value == value,
      orElse: () => UserRole.user,
    );
  }
}
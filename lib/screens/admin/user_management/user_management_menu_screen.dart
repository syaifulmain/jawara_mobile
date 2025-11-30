import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class UserManagementMenuScreen extends StatelessWidget {
  const UserManagementMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Manajemen Pengguna',
      menuItems: [
        SubMenuItem(
          icon: Icons.group,
          title: 'Daftar Pengguna',
          subtitle: 'Lihat semua pengguna',
          color: Colors.green,
          onTap: () => context.pushNamed('users_list'),
        ),
        SubMenuItem(
          icon: Icons.person_add,
          title: 'Tambah Pengguna',
          subtitle: 'Buat pengguna baru',
          color: Colors.green,
          onTap: () => context.pushNamed('add_user'),
        ),
      ],
    );
  }
}

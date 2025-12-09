import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class UserFamilyMenuScreen extends StatelessWidget {
  const UserFamilyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Data keluarga',
      menuItems: [
        SubMenuItem(
          icon: Icons.people,
          title: 'Profil Keluarga',
          subtitle: 'Lihat data keluarga Anda',
          color: Colors.red,
          onTap: () => context.pushNamed('family_profile'),
        ),
        SubMenuItem(
          icon: Icons.list_sharp,
          title: 'Daftar Anggota',
          subtitle: 'Lihat semua anggota keluarga',
          color: Colors.green,
          onTap: () => context.pushNamed('family_members'),
        ),
        SubMenuItem(
          icon: Icons.person_add,
          title: 'Tambah Anggota Keluarga',
          subtitle: 'Tambah anggota keluarga baru',
          color: Colors.yellow,
          onTap: () => context.pushNamed('add_user_family_member'),
        ),
      ],
    );
  }
}

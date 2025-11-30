import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class ResidentsAndHousesMenuScreen extends StatelessWidget {
  const ResidentsAndHousesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Data Warga dan Rumah',
      menuItems: [
        SubMenuItem(
          icon: Icons.people,
          title: 'Daftar Warga',
          subtitle: 'Lihat semua warga',
          color: Colors.blue,
          onTap: () => context.pushNamed('residents_list'),
        ),
        SubMenuItem(
          icon: Icons.person_add,
          title: 'Tambah Warga',
          subtitle: 'Tambah warga baru',
          color: Colors.blue,
          onTap: () => context.pushNamed('add_resident'),
        ),
        SubMenuItem(
          icon: Icons.family_restroom,
          title: 'Keluarga',
          subtitle: 'Kelola data keluarga',
          color: Colors.purple,
          onTap: () => context.pushNamed('families_list'),
        ),
        SubMenuItem(
          icon: Icons.home,
          title: 'Daftar Rumah',
          subtitle: 'Lihat semua rumah',
          color: Colors.orange,
          onTap: () => context.pushNamed('houses_list'),
        ),
        SubMenuItem(
          icon: Icons.add_home,
          title: 'Tambah Rumah',
          subtitle: 'Tambah rumah baru',
          color: Colors.orange,
          onTap: () => context.pushNamed('add_house'),
        ),
      ],
    );
  }
}

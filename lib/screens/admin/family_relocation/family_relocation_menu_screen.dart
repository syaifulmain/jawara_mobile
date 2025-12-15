import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class FamilyRelocationMenuScreen extends StatelessWidget {
  const FamilyRelocationMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Pindah Keluarga',
      menuItems: [
        SubMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Pindah Keluarga',
          subtitle: 'Lihat semua data pindah keluarga',
          color: Colors.orange,
          onTap: () => context.pushNamed('family_relocations_list'),
        ),
        SubMenuItem(
          icon: Icons.add_circle,
          title: 'Tambah Pindah Keluarga',
          subtitle: 'Tambah data pindah keluarga baru',
          color: Colors.orange,
          onTap: () => context.pushNamed('add_family_relocation'),
        ),
      ],
    );
  }
}
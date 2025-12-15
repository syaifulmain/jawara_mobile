import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class FamilyMutationMenuScreen extends StatelessWidget {
  const FamilyMutationMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Mutasi Keluarga',
      menuItems: [
        SubMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Mutasi',
          subtitle: 'Lihat semua mutasi keluarga',
          color: Colors.purple,
          onTap: () => context.pushNamed('family_relocation_list'),
        ),
        SubMenuItem(
          icon: Icons.add_circle,
          title: 'Tambah Mutasi',
          subtitle: 'Catat mutasi keluarga baru',
          color: Colors.purple,
          onTap: () => context.pushNamed('add_family_mutation'),
        ),
      ],
    );
  }
}

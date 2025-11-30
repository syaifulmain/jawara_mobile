import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class ExpenditureMenuScreen extends StatelessWidget {
  const ExpenditureMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Pengeluaran',
      menuItems: [
        SubMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Pengeluaran',
          subtitle: 'Lihat semua pengeluaran',
          color: Colors.red,
          onTap: () => context.pushNamed('expenditures_list'),
        ),
        SubMenuItem(
          icon: Icons.add_circle,
          title: 'Tambah Pengeluaran',
          subtitle: 'Catat pengeluaran baru',
          color: Colors.red,
          onTap: () => context.pushNamed('add_expenditure'),
        ),
      ],
    );
  }
}

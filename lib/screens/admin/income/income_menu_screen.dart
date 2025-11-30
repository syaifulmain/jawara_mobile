import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class IncomeMenuScreen extends StatelessWidget {
  const IncomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Pemasukan',
      menuItems: [
        SubMenuItem(
          icon: Icons.category,
          title: 'Kategori Iuran',
          subtitle: 'Kelola kategori iuran',
          color: Colors.blue,
          onTap: () => context.pushNamed('income_categories'),
        ),
        SubMenuItem(
          icon: Icons.payment,
          title: 'Tagih Iuran',
          subtitle: 'Buat tagihan iuran',
          color: Colors.blue,
          onTap: () => context.pushNamed('bill_income'),
        ),
        SubMenuItem(
          icon: Icons.receipt_long,
          title: 'Tagihan',
          subtitle: 'Lihat semua tagihan',
          color: Colors.orange,
          onTap: () => context.pushNamed('bills_list'),
        ),
        SubMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Pemasukan Lain',
          subtitle: 'Lihat pemasukan lainnya',
          color: Colors.green,
          onTap: () => context.pushNamed('other_income_list'),
        ),
        SubMenuItem(
          icon: Icons.add_circle,
          title: 'Tambah Pemasukan Lain',
          subtitle: 'Tambah pemasukan lainnya',
          color: Colors.green,
          onTap: () => context.pushNamed('add_other_income'),
        ),
      ],
    );
  }
}

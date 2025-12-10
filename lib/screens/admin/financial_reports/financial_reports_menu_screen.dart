import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class FinancialReportsMenuScreen extends StatelessWidget {
  const FinancialReportsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Laporan Keuangan',
      menuItems: [
        SubMenuItem(
          icon: Icons.trending_up,
          title: 'Semua Pemasukan',
          subtitle: 'Lihat laporan pemasukan',
          color: Colors.green,
          onTap: () => context.pushNamed('other_income_list'),
        ),
        SubMenuItem(
          icon: Icons.trending_down,
          title: 'Semua Pengeluaran',
          subtitle: 'Lihat laporan pengeluaran',
          color: Colors.red,
          onTap: () => context.pushNamed('expenditures_list'),
        ),
        SubMenuItem(
          icon: Icons.print,
          title: 'Cetak Laporan',
          subtitle: 'Cetak laporan keuangan',
          color: Colors.blue,
          onTap: () => context.pushNamed('print_financial_report'),
        ),
      ],
    );
  }
}

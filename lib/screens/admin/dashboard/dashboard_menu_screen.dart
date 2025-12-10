import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/menu_list_tile.dart';

class DashboardMenuScreen extends StatelessWidget {
  const DashboardMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuListTile(
              icon: Icons.account_balance_wallet,
              title: 'Keuangan',
              subtitle: 'Kelola data keuangan dan transaksi',
              color: Colors.green,
              onTap: () => context.pushNamed('dashboard-finance'),
            ),
            MenuListTile(
              icon: Icons.event_note,
              title: 'Kegiatan',
              subtitle: 'Kelola kegiatan dan acara',
              color: Colors.blue,
              onTap: () => context.pushNamed('dashboard-activities'),
            ),
            MenuListTile(
              icon: Icons.people_outline,
              title: 'Kependudukan',
              subtitle: 'Kelola data penduduk',
              color: Colors.orange,
              onTap: () => context.pushNamed('dashboard-population'),
            ),
          ],
        ),
      ),
    );
  }
}

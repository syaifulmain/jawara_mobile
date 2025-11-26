import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/menu_list_tile.dart';

class ActivitiesAndBroadcastMenuScreen extends StatelessWidget {
  const ActivitiesAndBroadcastMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kegiatan & Broadcast'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kelola Kegiatan & Broadcast',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            MenuListTile(
              icon: Icons.list_alt,
              title: 'Daftar Kegiatan',
              subtitle: 'Lihat semua kegiatan',
              color: Colors.blue,
              onTap: () => context.pushNamed('activities_list'),
            ),
            const SizedBox(height: 12),
            MenuListTile(
              icon: Icons.add_circle,
              title: 'Tambah Kegiatan',
              subtitle: 'Buat kegiatan baru',
              color: Colors.green,
              onTap: () => context.pushNamed('add_activity'),
            ),
            const SizedBox(height: 12),
            MenuListTile(
              icon: Icons.campaign,
              title: 'Daftar Broadcast',
              subtitle: 'Lihat semua broadcast',
              color: Colors.orange,
              onTap: () => context.pushNamed('broadcasts_list'),
            ),
            const SizedBox(height: 12),
            MenuListTile(
              icon: Icons.add_alert,
              title: 'Tambah Broadcast',
              subtitle: 'Buat broadcast baru',
              color: Colors.red,
              onTap: () => context.pushNamed('add_broadcast'),
            ),
          ],
        ),
      ),
    );
  }
}
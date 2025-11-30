import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class ActivitiesAndBroadcastMenuScreen extends StatelessWidget {
  const ActivitiesAndBroadcastMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Kegiatan & Broadcast',
      menuItems: [
        SubMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Kegiatan',
          subtitle: 'Lihat semua kegiatan',
          color: Colors.blue,
          onTap: () => context.pushNamed('activities_list'),
        ),
        SubMenuItem(
          icon: Icons.add_circle,
          title: 'Tambah Kegiatan',
          subtitle: 'Buat kegiatan baru',
          color: Colors.blue,
          onTap: () => context.pushNamed('add_activity'),
        ),
        SubMenuItem(
          icon: Icons.campaign,
          title: 'Daftar Broadcast',
          subtitle: 'Lihat semua broadcast',
          color: Colors.orange,
          onTap: () => context.pushNamed('broadcasts_list'),
        ),
        SubMenuItem(
          icon: Icons.add_alert,
          title: 'Tambah Broadcast',
          subtitle: 'Buat broadcast baru',
          color: Colors.orange,
          onTap: () => context.pushNamed('add_broadcast'),
        ),
      ],
    );
  }
}

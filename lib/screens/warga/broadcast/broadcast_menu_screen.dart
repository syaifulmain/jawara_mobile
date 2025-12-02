import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class ResidentBroadcastMenuScreen extends StatelessWidget {
  const ResidentBroadcastMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Broadcast',
      menuItems: [
        SubMenuItem(
          icon: Icons.calendar_view_week,
          title: 'Broadcast Minggu Ini',
          subtitle: 'Lihat broadcast minggu ini',
          color: Colors.purple,
          onTap: () => context.pushNamed('resident_broadcasts_this_week'),
        ),
        SubMenuItem(
          icon: Icons.campaign,
          title: 'Daftar Broadcast',
          subtitle: 'Lihat semua broadcast',
          color: Colors.orange,
          onTap: () => context.pushNamed('resident_broadcasts_list'),
        ),
      ],
    );
  }
}

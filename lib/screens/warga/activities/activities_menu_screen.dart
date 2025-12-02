// dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class ResidentActivitiesMenuScreen extends StatelessWidget {
  const ResidentActivitiesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Kegiatan',
      menuItems: [
        SubMenuItem(
          icon: Icons.calendar_today,
          title: 'Lihat Kegiatan Bulan Ini',
          subtitle: 'Lihat kegiatan di bulan ini',
          color: Colors.teal,
          onTap: () => context.pushNamed('resident_activities_this_month'),
        ),
        SubMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Kegiatan',
          subtitle: 'Lihat semua kegiatan',
          color: Colors.blue,
          onTap: () => context.pushNamed('resident_activities_list'),
        ),
      ],
    );
  }
}